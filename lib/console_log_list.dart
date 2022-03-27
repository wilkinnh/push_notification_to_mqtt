import 'dart:async';

import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:notifier_listener/notifier_listener.dart';
import 'package:built_collection/built_collection.dart';

import 'model/notification.dart' as DataModel;
import 'model/console_output.dart';
import 'model/notification_mqtt.dart';
import 'settings.dart';

class ConsoleLogList extends StatefulWidget {
  const ConsoleLogList({Key? key}) : super(key: key);

  @override
  _ConsoleLogListState createState() => _ConsoleLogListState();
}

class _ConsoleLogListState extends State<ConsoleLogList> {
  AndroidNotificationListener? _notifications;
  StreamSubscription<NotifierListenerEvent>? _subscription;
  List<ConsoleOutput> _consoleOutput = List.empty(growable: true);
  List<DataModel.ProcessedNotification> _processedNotifications = List.empty(growable: true);
  List<NotificationMQTT> _notificationParsers = List.empty(growable: true);
  MqttServerClient? _mqttServerClient;
  List<Application> _apps = List.empty();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    loadApps();
    startMQTTServerClient();
    startListening();
  }

  Future<void> loadApps() async {
    List<Application> apps = await DeviceApps.getInstalledApplications(
        onlyAppsWithLaunchIntent: true, includeAppIcons: true, includeSystemApps: true);
    setState(() {
      _apps = apps;
    });
  }

  Future<void> startMQTTServerClient() async {
    final client = MqttServerClient('homeassistant.local', '');

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

  void startListening() {
    var listener = AndroidNotificationListener();
    _notifications = listener;
    try {
      _subscription = listener.notificationStream?.listen(onData);
    } on NotifierListener catch (exception) {
      print(exception);
    }
  }

  void stopListening() {
    _subscription?.cancel();
  }

  void onData(NotifierListenerEvent event) {
    logConsoleOutput(
        'Notification received for ${event.packageName}:\nText: ${event.packageText}\nMessage: ${event.packageMessage}');

    final notification = DataModel.Notification((b) => b
      ..packageName = event.packageName
      ..message = event.packageMessage
      ..text = event.packageText
      ..timestamp = event.timeStamp);

    processNotification(notification);
  }

  void processNotification(DataModel.Notification notification) {
    var matches = List<NotificationMQTT>.empty(growable: true);

    _notificationParsers.forEach((parser) {
      if (parser.packageName != notification.packageName) {
        // only match if packageNames match
        return;
      }
      final regex = RegExp(parser.regex);
      final textMatch = regex.firstMatch(notification.text)?.group(0);
      final messageMatch = regex.firstMatch(notification.message)?.group(0);
      // check if first match equals the regexMatch
      if (textMatch == parser.regexMatch || messageMatch == parser.regexMatch) {
        if (textMatch != null) {
          logConsoleOutput('Notification regex match in text: ${parser.regexMatch} in ${parser.regex}');
        }
        if (messageMatch != null) {
          logConsoleOutput('Notification regex match in message: ${parser.regexMatch} in ${parser.regex}');
        }

        matches.add(parser);

        // publish MQTT message
        publishMQTTMessage(notification, parser);
      }
    });

    final processedNotification = DataModel.ProcessedNotification((b) => b
      ..notification = notification.toBuilder()
      ..regexMatches = BuiltList<NotificationMQTT>(matches).toBuilder());

    _processedNotifications.insert(0, processedNotification);
  }

  Future<void> publishMQTTMessage(DataModel.Notification notification, NotificationMQTT parser) async {
    final builder = MqttClientPayloadBuilder();

    if (parser.dataRegex != null) {
      final regex = RegExp(parser.dataRegex!);
      final textMatch = regex.firstMatch(notification.text)?.group(0);
      final messageMatch = regex.firstMatch(notification.message)?.group(0);
      if (textMatch != null) {
        logConsoleOutput('Notification data regex match: $textMatch in ${parser.dataRegex!}');
        builder.addString(textMatch);
      }
      if (messageMatch != null) {
        logConsoleOutput('Notification regex match: $messageMatch in ${parser.dataRegex!}');
        builder.addString(messageMatch);
      }
    }
    _mqttServerClient?.publishMessage(parser.publishTopic, MqttQos.exactlyOnce, builder.payload!);
  }

  void logConsoleOutput(String message) {
    final consoleOutput = ConsoleOutput((b) => b
      ..timestamp = DateTime.now()
      ..message = message);

    setState(() {
      _consoleOutput.insert(0, consoleOutput);
    });
  }

  void clearConsoleLog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Clear Console Log?"),
          content: const Text("This action cannot be undone."),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Clear"),
              onPressed: () {
                setState(() {
                  _consoleOutput.clear();
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  ApplicationWithIcon? iconForPackageName(String packageName) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Push Notifications to MQTT"),
        leading: IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Settings()),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear_all),
            onPressed: () {
              clearConsoleLog(context);
            },
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            child: Text("${_notificationParsers.length} rule${_notificationParsers.length == 1 ? "" : "s"} loaded"),
          ),
          const Divider(height: 1),
          SingleChildScrollView(
            child: Table(
              border: TableBorder.all(color: Colors.grey),
              children: List<TableRow>.generate(_consoleOutput.length, (index) {
                final consoleOutput = _consoleOutput[index];
                return TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 5, 10, 5),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child:
                                consoleOutput.icon != null ? Image.memory(consoleOutput.icon!) : const Icon(Icons.apps),
                          ),
                          Flexible(
                            child: Text(
                              "[${consoleOutput.timestamp.toString()}] " + consoleOutput.message,
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
        onPressed: () {
          final event = NotifierListenerEvent(
              packageName: 'com.h4wkd.test',
              packageText: 'This is my text',
              packageMessage: 'This is my message',
              timeStamp: DateTime.now());
          onData(event);
        },
      ),
    );
  }
}
