import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

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
