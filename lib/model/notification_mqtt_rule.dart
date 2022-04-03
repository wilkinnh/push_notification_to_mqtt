import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'serializers.dart';

part 'notification_mqtt_rule.g.dart';

abstract class NotificationMQTTRule implements Built<NotificationMQTTRule, NotificationMQTTRuleBuilder> {
  static Serializer<NotificationMQTTRule> get serializer => _$notificationMQTTRuleSerializer;

  String get packageName;

  String get regex;

  String? get regexMatch;

  String? get dataRegex;

  String get publishTopic;

  NotificationMQTTRule._();

  factory NotificationMQTTRule([void Function(NotificationMQTTRuleBuilder) updates]) = _$NotificationMQTTRule;

  String toJson() {
    return json.encode(serializers.serializeWith(NotificationMQTTRule.serializer, this));
  }

  static NotificationMQTTRule? fromJson(String jsonString) {
    return serializers.deserializeWith(NotificationMQTTRule.serializer, json.decode(jsonString));
  }
}
