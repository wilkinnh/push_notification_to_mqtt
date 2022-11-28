import 'dart:convert';

import 'package:mqtt_client/mqtt_client.dart';

extension MQTTPayloadString on MqttClientPayloadBuilder {
  String payloadString() {
    if (payload == null) {
      return "";
    }
    const decoder = Utf8Decoder();
    return decoder.convert(payload!);
  }
}
