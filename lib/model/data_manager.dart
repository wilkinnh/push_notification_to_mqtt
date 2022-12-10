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
import 'mqtt_client_payload_builder_string.dart';

enum SharedPreferenceKey { rulesURL, mqttServerURL, mqttUsername, mqttPassword }

class DataManager with ChangeNotifier {
  List<NotificationMQTTRule> rules = [];
  List<ConsoleOutput> consoleOutput = [];
  Set<String> consoleOutputPackageNameFilter = {};

  String? _rulesURL;
  String? _mqttServerURL;
  String? _mqttUsername;
  String? _mqttPassword;

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

    final loadedMQTTUsername = prefs.getString(SharedPreferenceKey.mqttUsername.toString());
    if (loadedMQTTUsername != null) {
      _mqttUsername = loadedMQTTUsername;
    }

    final loadedMQTTPassword = prefs.getString(SharedPreferenceKey.mqttPassword.toString());
    if (loadedMQTTPassword != null) {
      _mqttPassword = loadedMQTTPassword;
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
    _setPreference(SharedPreferenceKey.rulesURL.toString(), rulesURL);
  }

  String? get mqttServerURL {
    return _mqttServerURL;
  }

  set mqttServerURL(String? mqttServerURL) {
    _mqttServerURL = mqttServerURL;
    _setPreference(SharedPreferenceKey.mqttServerURL.toString(), mqttServerURL);
  }

  String? get mqttUsername {
    return _mqttUsername;
  }

  set mqttUsername(String? mqttUsername) {
    _mqttUsername = mqttUsername;
    _setPreference(SharedPreferenceKey.mqttUsername.toString(), mqttUsername);
  }

  String? get mqttPassword {
    return _mqttPassword;
  }

  set mqttPassword(String? mqttPassword) {
    _mqttPassword = mqttPassword;
    _setPreference(SharedPreferenceKey.mqttPassword.toString(), mqttPassword);
  }

  Future<void> _setPreference(String key, String? value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value != null) {
      prefs.setString(key, value);
    } else {
      prefs.remove(key);
    }
  }

  List<ConsoleOutput> get filteredConsoleOutput {
    if (consoleOutputPackageNameFilter.isEmpty) {
      return consoleOutput;
    }
    return consoleOutput
        .where((consoleOutput) =>
            consoleOutputPackageNameFilter.any((filter) => filter == consoleOutput.notification?.packageName))
        .toList();
  }

  // Reload rules

  Future<List<NotificationMQTTRule>> reloadRules() async {
    if (rulesURL == null) {
      logConsoleOutput(null, "reload rules failed: no rules URL detected");
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
    } else {
      logConsoleOutput(null, "reload rules failed: loaded rules are empty");
    }
    return rules;
  }

  Future<void> _notifyReload() async {
    // sent MQTT message after successful reload
    final builder = MqttClientPayloadBuilder();
    builder.addString('${rules.length}');
    _mqttServerClient?.publishMessage('notification-mqtt-rules-loaded', MqttQos.exactlyOnce, builder.payload!);
    logConsoleOutput(null, '${rules.length} rules reloaded');
  }

  // MQTT

  Future<void> _startMQTTServerClient() async {
    if (mqttServerURL == null) {
      print('[MQTT] server url undefined');
      return;
    }

    final client = MqttServerClient(mqttServerURL!, '');

    /// Set the correct MQTT protocol for mosquito
    client.logging(on: false);
    client.setProtocolV311();
    client.keepAlivePeriod = 20;
    client.onDisconnected = _onMQTTDisconnected;
//    client.onSubscribed = onSubscribed;

    final connMess = MqttConnectMessage()
        .withClientIdentifier('Mqtt_MyClientUniqueIdQ2')
        .withWillTopic('willtopic') // If you set this you must set a will message
        .withWillMessage('My Will message')
        .startClean() // Non persistent session for testing
        .withWillQos(MqttQos.atLeastOnce);
    client.connectionMessage = connMess;

    try {
      if (mqttUsername != null && mqttPassword != null) {
        await client.connect(mqttUsername, mqttPassword);
      } else {
        await client.connect();
      }
    } on Exception catch (e) {
      print('[MQTT] client exception - $e');
      client.disconnect();
    }

    /// Check we are connected
    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      print('[MQTT] Mosquitto client connected');
    } else {
      print(
          '[MQTT] ERROR Mosquitto client connection failed - disconnecting, state is ${client.connectionStatus!.state}');
      client.disconnect();
      return;
    }

    _mqttServerClient = client;
  }

  void _onMQTTDisconnected() {
    _mqttServerClient = null;
    print('[MQTT] Mosquitto client disconnected');
  }

  Future<void> _publishMQTTMessage(DataModel.Notification notification, NotificationMQTTRule rule) async {
    if (_mqttServerClient == null) {
      await _startMQTTServerClient();
      if (_mqttServerClient == null) {
        print('[MQTT] unable to start MQTT client');
        return;
      }
    }

    Map<String, String> payload = {"title": notification.text, "message": notification.message};
    List<String> dataParameters = [];

    if (rule.titleRegex != null) {
      final regex = RegExp(rule.titleRegex!);
      final match = regex.firstMatch(notification.text);
      if (match != null && match.groupCount > 0) {
        for (var i = 0; i < match.groupCount; i++) {
          final groupValue = match.group(i + 1);
          if (groupValue != null) {
            print('title match \'${rule.titleRegex}\' group $i value: $groupValue');
            payload["titleMatch"] = groupValue;
          }
        }
      }
    }

    if (rule.messageRegex != null) {
      final regex = RegExp(rule.messageRegex!);
      final match = regex.firstMatch(notification.message);
      if (match != null && match.groupCount > 0) {
        for (var i = 0; i < match.groupCount; i++) {
          final groupValue = match.group(i + 1);
          if (groupValue != null) {
            print('message match \'${rule.messageRegex}\' group $i value: $groupValue');
            payload["messageMatch"] = groupValue;
          }
        }
      }
    }

    final builder = MqttClientPayloadBuilder();
    builder.addString(json.encode(payload));

    print('[MQTT] publish to ${rule.publishTopic}: ${payload.toString()}');
    logConsoleOutput(notification, 'MQTT ${rule.publishTopic}: ${payload.toString()}');
    _mqttServerClient?.publishMessage(rule.publishTopic, MqttQos.exactlyOnce, builder.payload!);
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
    // suppress android system notifications
    if (event.packageName == "com.android.systemui") {
      return;
    }

    final notification = DataModel.Notification((b) => b
      ..packageName = event.packageName
      ..message = event.packageMessage
      ..text = event.packageText
      ..timestamp = event.timeStamp);

    logConsoleOutput(notification,
        'Notification received for ${event.packageName}:\nText: ${event.packageText}\nMessage: ${event.packageMessage}');

    processRemoteNotification(notification);
  }

  void processRemoteNotification(DataModel.Notification notification) {
    // check for reload notification
    if (notification.packageName == 'io.homeassistant.companion.android' &&
        notification.text == 'Notification MQTT' &&
        notification.message == 'reload') {
      reloadRules();
    }

    var matches = List<NotificationMQTTRule>.empty(growable: true);

    for (var notificationRule in rules) {
      if (notificationRule.packageName != notification.packageName) {
        // only match if packageNames match
        continue;
      }
      bool? hasTitleRegexMatch;
      bool? hasMessageRegexMatch;
      if (notificationRule.titleRegex != null) {
        final regex = RegExp(notificationRule.titleRegex!);
        final hasMatch = regex.hasMatch(notification.text);
        if (hasMatch) {
          logConsoleOutput(
              notification, 'regex match in title: ${notification.text}\nregex: ${notificationRule.titleRegex}');
          hasTitleRegexMatch = true;
        } else {
          hasTitleRegexMatch = false;
        }
      }
      if (notificationRule.messageRegex != null) {
        final regex = RegExp(notificationRule.messageRegex!);
        final hasMatch = regex.hasMatch(notification.message);
        if (hasMatch) {
          logConsoleOutput(
              notification, 'regex match in message: ${notification.message}\nregex: ${notificationRule.messageRegex}');
          hasMessageRegexMatch = true;
        } else {
          hasMessageRegexMatch = false;
        }
      }

      // check if there's a valid regex match
      bool hasRegexMatch;
      if (hasTitleRegexMatch != null && hasMessageRegexMatch != null) {
        // if both title and message regex is provided, both must match
        hasRegexMatch = hasTitleRegexMatch == true && hasMessageRegexMatch == true;
      } else {
        hasRegexMatch = hasTitleRegexMatch == true || hasMessageRegexMatch == true;
      }

      if (hasRegexMatch) {
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

  void logConsoleOutput(DataModel.Notification? notification, String message) {
    final app = _apps.firstWhereOrNull((app) => app.packageName == notification?.packageName);
    final output = ConsoleOutput((b) => b
      ..timestamp = DateTime.now()
      ..message = message
      ..notification = notification?.toBuilder()
      ..icon = app?.icon);
    consoleOutput.insert(0, output);
    notifyListeners();
  }

  void clearConsoleLogs() {
    consoleOutput.clear();
    notifyListeners();
  }

  void toggleConsoleOutputForApp(String packageName) {
    if (consoleOutputPackageNameFilter.any((filter) => filter == packageName)) {
      consoleOutputPackageNameFilter.remove(packageName);
    } else {
      consoleOutputPackageNameFilter.add(packageName);
    }
    notifyListeners();
  }

  List<ApplicationWithIcon> receivedNotificationApplications() {
    return _apps
        .where(
            (app) => consoleOutput.any((consoleOutput) => consoleOutput.notification?.packageName == app.packageName))
        .toList();
  }
}
