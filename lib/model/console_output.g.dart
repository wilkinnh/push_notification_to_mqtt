// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'console_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<ConsoleOutput> _$consoleOutputSerializer =
    new _$ConsoleOutputSerializer();

class _$ConsoleOutputSerializer implements StructuredSerializer<ConsoleOutput> {
  @override
  final Iterable<Type> types = const [ConsoleOutput, _$ConsoleOutput];
  @override
  final String wireName = 'ConsoleOutput';

  @override
  Iterable<Object?> serialize(Serializers serializers, ConsoleOutput object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'timestamp',
      serializers.serialize(object.timestamp,
          specifiedType: const FullType(DateTime)),
      'message',
      serializers.serialize(object.message,
          specifiedType: const FullType(String)),
    ];
    Object? value;
    value = object.icon;
    if (value != null) {
      result
        ..add('icon')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(Uint8List)));
    }
    return result;
  }

  @override
  ConsoleOutput deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ConsoleOutputBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'timestamp':
          result.timestamp = serializers.deserialize(value,
              specifiedType: const FullType(DateTime)) as DateTime;
          break;
        case 'message':
          result.message = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'icon':
          result.icon = serializers.deserialize(value,
              specifiedType: const FullType(Uint8List)) as Uint8List?;
          break;
      }
    }

    return result.build();
  }
}

class _$ConsoleOutput extends ConsoleOutput {
  @override
  final DateTime timestamp;
  @override
  final String message;
  @override
  final Uint8List? icon;

  factory _$ConsoleOutput([void Function(ConsoleOutputBuilder)? updates]) =>
      (new ConsoleOutputBuilder()..update(updates)).build();

  _$ConsoleOutput._({required this.timestamp, required this.message, this.icon})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        timestamp, 'ConsoleOutput', 'timestamp');
    BuiltValueNullFieldError.checkNotNull(message, 'ConsoleOutput', 'message');
  }

  @override
  ConsoleOutput rebuild(void Function(ConsoleOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ConsoleOutputBuilder toBuilder() => new ConsoleOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ConsoleOutput &&
        timestamp == other.timestamp &&
        message == other.message &&
        icon == other.icon;
  }

  @override
  int get hashCode {
    return $jf(
        $jc($jc($jc(0, timestamp.hashCode), message.hashCode), icon.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('ConsoleOutput')
          ..add('timestamp', timestamp)
          ..add('message', message)
          ..add('icon', icon))
        .toString();
  }
}

class ConsoleOutputBuilder
    implements Builder<ConsoleOutput, ConsoleOutputBuilder> {
  _$ConsoleOutput? _$v;

  DateTime? _timestamp;
  DateTime? get timestamp => _$this._timestamp;
  set timestamp(DateTime? timestamp) => _$this._timestamp = timestamp;

  String? _message;
  String? get message => _$this._message;
  set message(String? message) => _$this._message = message;

  Uint8List? _icon;
  Uint8List? get icon => _$this._icon;
  set icon(Uint8List? icon) => _$this._icon = icon;

  ConsoleOutputBuilder();

  ConsoleOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _timestamp = $v.timestamp;
      _message = $v.message;
      _icon = $v.icon;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ConsoleOutput other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ConsoleOutput;
  }

  @override
  void update(void Function(ConsoleOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  _$ConsoleOutput build() {
    final _$result = _$v ??
        new _$ConsoleOutput._(
            timestamp: BuiltValueNullFieldError.checkNotNull(
                timestamp, 'ConsoleOutput', 'timestamp'),
            message: BuiltValueNullFieldError.checkNotNull(
                message, 'ConsoleOutput', 'message'),
            icon: icon);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,deprecated_member_use_from_same_package,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
