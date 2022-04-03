import 'dart:async';
import 'dart:convert';

import 'package:device_apps/device_apps.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:notifier_listener/notifier_listener.dart';
import 'package:built_collection/built_collection.dart';
import 'package:http/http.dart' as http;
import 'package:collection/collection.dart';

import 'notification_mqtt_rule.dart';
import 'notification.dart' as DataModel;
import 'console_output.dart';

enum SharedPreferenceKey { rulesURL, mqttServerURL }

class DataManager with ChangeNotifier {
  List<NotificationMQTTRule> rules = [];
  List<ConsoleOutput> consoleOutput = [];

  String? _rulesURL;
  String? _mqttServerURL;

  final http.Client _client = http.Client();
  AndroidNotificationListener? _notifications;
  StreamSubscription<NotifierListenerEvent>? _subscription;
  final List<DataModel.ProcessedNotification> _processedNotifications = List.empty(growable: true);
  MqttServerClient? _mqttServerClient;
  List<ApplicationWithIcon> _apps = List.empty();

  DataManager() {
    _loadSettings();
    _loadApps();
    _startMQTTServerClient();
    _startRemoteNotificationListener();

    Timer.periodic(const Duration(hours: 1), (timer) {
      reloadRules();
    });
  }

  Future<void> _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final loadedMQTTServerURL = prefs.getString(SharedPreferenceKey.mqttServerURL.toString());
    if (loadedMQTTServerURL != null) {
      _mqttServerURL = loadedMQTTServerURL;
    }
    final loadedRulesURL = prefs.getString(SharedPreferenceKey.rulesURL.toString());
    if (loadedRulesURL != null) {
      _rulesURL = loadedRulesURL;
      reloadRules();
    }
    notifyListeners();
  }

  Future<void> _loadApps() async {
    List<Application> apps = await DeviceApps.getInstalledApplications(
        onlyAppsWithLaunchIntent: true, includeAppIcons: true, includeSystemApps: true);
    List<ApplicationWithIcon> appsWithIcons =
        apps.map<ApplicationWithIcon>((app) => app as ApplicationWithIcon).toList();
    _apps = appsWithIcons;
    notifyListeners();
  }

  // Getters/Setters

  String? get rulesURL {
    return _rulesURL;
  }

  set rulesURL(String? rulesURL) {
    _rulesURL = rulesURL;
    if (rulesURL != null) {
      SharedPreferences.getInstance().then((prefs) {
        prefs.setString(SharedPreferenceKey.rulesURL.toString(), rulesURL);
      });
    }
  }

  String? get mqttServerURL {
    return _mqttServerURL;
  }

  set mqttServerURL(String? mqttServerURL) {
    _mqttServerURL = mqttServerURL;
    if (mqttServerURL != null) {
      SharedPreferences.getInstance().then((prefs) {
        prefs.setString(SharedPreferenceKey.mqttServerURL.toString(), mqttServerURL);
      });
    }
  }

  // Reload rules

  Future<List<NotificationMQTTRule>> reloadRules() async {
    if (rulesURL == null) {
      return [];
    }
    final response = await _client.get(Uri.parse(rulesURL!));
    final List<dynamic> parsed = jsonDecode(response.body);
    final List<NotificationMQTTRule> loadedRules = parsed
        .map<NotificationMQTTRule?>((item) {
          final jsonString = jsonEncode(item);
          return NotificationMQTTRule.fromJson(jsonString);
        })
        .whereNotNull()
        .toList();
    if (loadedRules.isNotEmpty) {
      rules = loadedRules;
      _notifyReload();
      notifyListeners();
    }
    return rules;
  }

  Future<void> _notifyReload() async {
    // sent MQTT message after successful reload
    final builder = MqttClientPayloadBuilder();
    builder.addInt(rules.length);
    _mqttServerClient?.publishMessage('notification-mqtt-rules-loaded', MqttQos.exactlyOnce, builder.payload!);
  }

  // MQTT

  Future<void> _startMQTTServerClient() async {
    if (mqttServerURL == null) {
      print('MQTT server url undefined');
      return;
    }

    final client = MqttServerClient(mqttServerURL!, '');

    /// Set the correct MQTT protocol for mosquito
    client.logging(on: false);
    client.setProtocolV311();
    client.keepAlivePeriod = 20;
//    client.onDisconnected = onDisconnected;
//    client.onSubscribed = onSubscribed;

    final connMess = MqttConnectMessage()
        .withClientIdentifier('Mqtt_MyClientUniqueIdQ2')
        .withWillTopic('willtopic') // If you set this you must set a will message
        .withWillMessage('My Will message')
        .startClean() // Non persistent session for testing
        .withWillQos(MqttQos.atLeastOnce);
    client.connectionMessage = connMess;

    try {
      await client.connect();
    } on Exception catch (e) {
      print('EXAMPLE::client exception - $e');
      client.disconnect();
    }

    /// Check we are connected
    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      print('EXAMPLE::Mosquitto client connected');
    } else {
      print(
          'EXAMPLE::ERROR Mosquitto client connection failed - disconnecting, state is ${client.connectionStatus!.state}');
      client.disconnect();
      return;
    }

    _mqttServerClient = client;
  }

  Future<void> _publishMQTTMessage(DataModel.Notification notification, NotificationMQTTRule parser) async {
    if (_mqttServerClient == null) {
      await _startMQTTServerClient();
      if (_mqttServerClient == null) {
        print('unable to start MQTT client');
        return;
      }
    }

    final builder = MqttClientPayloadBuilder();

    if (parser.dataRegex != null) {
      final regex = RegExp(parser.dataRegex!);
      final textMatch = regex.firstMatch(notification.text)?.group(0);
      final messageMatch = regex.firstMatch(notification.message)?.group(0);
      if (textMatch != null) {
        logConsoleOutput(
            notification.packageName, 'Notification data regex match in text: $textMatch in ${parser.dataRegex!}');
        builder.addString(textMatch);
      }
      if (messageMatch != null) {
        logConsoleOutput(notification.packageName,
            'Notification data regex match in message: $messageMatch in ${parser.dataRegex!}');
        builder.addString(messageMatch);
      }
    }
    _mqttServerClient?.publishMessage(parser.publishTopic, MqttQos.exactlyOnce, builder.payload!);
  }

  // Remote notifications

  void _startRemoteNotificationListener() {
    var listener = AndroidNotificationListener();
    _notifications = listener;
    try {
      _subscription = listener.notificationStream?.listen(_onRemoteNotificationReceived);
    } on NotifierListener catch (exception) {
      print(exception);
    }
  }

  void _stopRemoteNotificationListening() {
    _subscription?.cancel();
  }

  void _onRemoteNotificationReceived(NotifierListenerEvent event) {
    logConsoleOutput(event.packageName,
        'Notification received for ${event.packageName}:\nText: ${event.packageText}\nMessage: ${event.packageMessage}');

    final notification = DataModel.Notification((b) => b
      ..packageName = event.packageName
      ..message = event.packageMessage
      ..text = event.packageText
      ..timestamp = event.timeStamp);

    _processRemoteNotification(notification);
  }

  void _processRemoteNotification(DataModel.Notification notification) {
    var matches = List<NotificationMQTTRule>.empty(growable: true);

    for (var notificationRule in rules) {
      if (notificationRule.packageName != notification.packageName) {
        // only match if packageNames match
        return;
      }
      final regex = RegExp(notificationRule.regex);
      final textMatch = regex.firstMatch(notification.text)?.group(0);
      final messageMatch = regex.firstMatch(notification.message)?.group(0);
      // check if first match equals the regexMatch
      if (textMatch == notificationRule.regexMatch ||
          messageMatch == notificationRule.regexMatch ||
          notificationRule.regexMatch == null) {
        if (notificationRule.regexMatch == null) {
          logConsoleOutput(notification.packageName, 'Notification regex match');
        } else if (textMatch != null) {
          logConsoleOutput(notification.packageName,
              'Notification regex match in text: ${notificationRule.regexMatch} in ${notificationRule.regex}');
        } else if (messageMatch != null) {
          logConsoleOutput(notification.packageName,
              'Notification regex match in message: ${notificationRule.regexMatch} in ${notificationRule.regex}');
        }

        matches.add(notificationRule);

        // publish MQTT message
        _publishMQTTMessage(notification, notificationRule);
      }
    }

    final processedNotification = DataModel.ProcessedNotification((b) => b
      ..notification = notification.toBuilder()
      ..regexMatches = BuiltList<NotificationMQTTRule>(matches).toBuilder());

    _processedNotifications.insert(0, processedNotification);
  }

  // Console output

  void logConsoleOutput(String? packageName, String message) {
    final app = _apps.firstWhereOrNull((app) => app.packageName == packageName);
    final output = ConsoleOutput((b) => b
      ..timestamp = DateTime.now()
      ..message = message
      ..icon = app?.icon);
    consoleOutput.insert(0, output);
    notifyListeners();
  }

  void clearConsoleLogs() {
    consoleOutput.clear();
    notifyListeners();
  }
}
