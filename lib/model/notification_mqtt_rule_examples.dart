import 'notification_mqtt_rule.dart';

extension ExampleRules on NotificationMQTTRule {
  List<NotificationMQTTRule> exampleRules() {
    return [
      NotificationMQTTRule((b) => b
        ..packageName = 'com.h4wkd.test'
        ..titleRegex = '^Arsenal scores!\$'
        ..messageRegex = 'Arsenal'
        ..publishTopic = 'arsenal-goal'),
    ];
  }
}
