import 'dart:html';

import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'dart:async';
import 'dart:convert';
import 'package:notifier_listener/notifier_listener.dart';
import 'package:push_notification_to_mqtt/model/notification_mqtt.dart';
import 'package:built_collection/built_collection.dart';

import 'model/notification.dart' as DataModel;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Push Notification Listener to MQTT',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  AndroidNotificationListener? _notifications;
  StreamSubscription<NotifierListenerEvent>? _subscription;
  List<DataModel.ProcessedNotification> _processedNotifications = List.empty(growable: true);
  List<NotificationMQTT> _notificationParsers = List.empty(growable: true);
  MqttServerClient? _mqttServerClient;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    startMQTTServerClient();
    startListening();
  }

  Future<void> startMQTTServerClient() async {
    final client = MqttServerClient('home.natewilkinson.com', '');

    /// Set the correct MQTT protocol for mosquito
    client.setProtocolV311();
    client.logging(on: false);
//    client.keepAlivePeriod = 20;
//    client.onDisconnected = onDisconnected;
//    client.onSubscribed = onSubscribed;
//    final connMess = MqttConnectMessage()
//        .withClientIdentifier('Mqtt_MyClientUniqueIdQ2')
//        .withWillTopic('willtopic') // If you set this you must set a will message
//        .withWillMessage('My Will message')
//        .startClean() // Non persistent session for testing
//        .withWillQos(MqttQos.atLeastOnce);
//    print('EXAMPLE::Mosquitto client connecting....');
//    client.connectionMessage = connMess;

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
    print(event);

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
      final match = regex.firstMatch(notification.text);
      // check if first match equals the regexMatch
      if (match?.group(0) == parser.regexMatch) {
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
    final builder1 = MqttClientPayloadBuilder();
    builder1.addString('Hello from mqtt_client topic 1');
    print('EXAMPLE:: <<<< PUBLISH 1 >>>>');
    _mqttServerClient?.publishMessage(parser.publishTopic, MqttQos.exactlyOnce, builder1.payload!);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Table(
          children: List<TableRow>.generate(_processedNotifications.length, (index) {
            final processedNotification = _processedNotifications[index];
            return TableRow(children: [
              ListView(
                children: [
                  Text('PackageName: ' + processedNotification.notification.packageName),
                  Text('Text: ' + processedNotification.notification.text),
                  Text('Message: ' + processedNotification.notification.message),
                  Text('Timestamp: ' + processedNotification.notification.timestamp.toString()),
                ],
              )
            ]);
          }),
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
      ),
    );
  }
}
