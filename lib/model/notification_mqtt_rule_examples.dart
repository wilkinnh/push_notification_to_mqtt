import 'notification_mqtt_rule.dart';

extension ExampleRules on NotificationMQTTRule {
  List<NotificationMQTTRule> exampleRules() {
    return [
      NotificationMQTTRule((b) => b
        ..packageName = 'com.h4wkd.test'
        ..regex = '^(.*) scores!\$'
        ..regexMatch = 'Arsenal'
        ..dataRegex = '^.+\\[(\\d)\\].*\$'
        ..publishTopic = 'android-notification'),
    ];
  }
}
