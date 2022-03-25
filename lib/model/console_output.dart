import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'console_output.g.dart';

abstract class ConsoleOutput implements Built<ConsoleOutput, ConsoleOutputBuilder> {
  static Serializer<ConsoleOutput> get serializer => _$consoleOutputSerializer;

  DateTime get timestamp;

  String get message;

  ConsoleOutput._();
  factory ConsoleOutput([void Function(ConsoleOutputBuilder) updates]) = _$ConsoleOutput;
}
