import 'dart:typed_data';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'notification.dart' as DataModel;

part 'console_output.g.dart';

abstract class ConsoleOutput implements Built<ConsoleOutput, ConsoleOutputBuilder> {
  static Serializer<ConsoleOutput> get serializer => _$consoleOutputSerializer;

  DateTime get timestamp;

  String get message;

  DataModel.Notification? get notification;

  Uint8List? get icon;

  ConsoleOutput._();
  factory ConsoleOutput([void Function(ConsoleOutputBuilder) updates]) = _$ConsoleOutput;
}
