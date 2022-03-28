import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';

import 'notification_mqtt_rule.dart';

part 'serializers.g.dart';

@SerializersFor(const [
  NotificationMQTTRule,
])
final Serializers serializers = (_$serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();
