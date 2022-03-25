import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'notification_mqtt.g.dart';

abstract class NotificationMQTT implements Built<NotificationMQTT, NotificationMQTTBuilder> {
  static Serializer<NotificationMQTT> get serializer => _$notificationMQTTSerializer;

  String get packageName;

  String get regex;

  String get regexMatch;

  String? get dataRegex;

  String get publishTopic;

  NotificationMQTT._();
  factory NotificationMQTT([void Function(NotificationMQTTBuilder) updates]) = _$NotificationMQTT;
}
