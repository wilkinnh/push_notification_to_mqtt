import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:push_notification_to_mqtt/model/notification_mqtt.dart';

part 'notification.g.dart';

abstract class Notification implements Built<Notification, NotificationBuilder> {
  static Serializer<Notification> get serializer => _$notificationSerializer;

  String get packageName;

  String get message;

  String get text;

  DateTime get timestamp;

  Notification._();
  factory Notification([void Function(NotificationBuilder) updates]) = _$Notification;
}

abstract class ProcessedNotification implements Built<ProcessedNotification, ProcessedNotificationBuilder> {
  static Serializer<ProcessedNotification> get serializer => _$processedNotificationSerializer;

  Notification get notification;

  BuiltList<NotificationMQTT> get regexMatches;

  ProcessedNotification._();
  factory ProcessedNotification([void Function(ProcessedNotificationBuilder) updates]) = _$ProcessedNotification;
}
