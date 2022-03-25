// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<Notification> _$notificationSerializer =
    new _$NotificationSerializer();

class _$NotificationSerializer implements StructuredSerializer<Notification> {
  @override
  final Iterable<Type> types = const [Notification, _$Notification];
  @override
  final String wireName = 'Notification';

  @override
  Iterable<Object?> serialize(Serializers serializers, Notification object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'packageName',
      serializers.serialize(object.packageName,
          specifiedType: const FullType(String)),
      'message',
      serializers.serialize(object.message,
          specifiedType: const FullType(String)),
      'text',
      serializers.serialize(object.text, specifiedType: const FullType(String)),
      'timestamp',
      serializers.serialize(object.timestamp,
          specifiedType: const FullType(DateTime)),
    ];

    return result;
  }

  @override
  Notification deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new NotificationBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'packageName':
          result.packageName = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'message':
          result.message = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'text':
          result.text = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'timestamp':
          result.timestamp = serializers.deserialize(value,
              specifiedType: const FullType(DateTime)) as DateTime;
          break;
      }
    }

    return result.build();
  }
}

class _$Notification extends Notification {
  @override
  final String packageName;
  @override
  final String message;
  @override
  final String text;
  @override
  final DateTime timestamp;

  factory _$Notification([void Function(NotificationBuilder)? updates]) =>
      (new NotificationBuilder()..update(updates)).build();

  _$Notification._(
      {required this.packageName,
      required this.message,
      required this.text,
      required this.timestamp})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        packageName, 'Notification', 'packageName');
    BuiltValueNullFieldError.checkNotNull(message, 'Notification', 'message');
    BuiltValueNullFieldError.checkNotNull(text, 'Notification', 'text');
    BuiltValueNullFieldError.checkNotNull(
        timestamp, 'Notification', 'timestamp');
  }

  @override
  Notification rebuild(void Function(NotificationBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  NotificationBuilder toBuilder() => new NotificationBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Notification &&
        packageName == other.packageName &&
        message == other.message &&
        text == other.text &&
        timestamp == other.timestamp;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc($jc($jc(0, packageName.hashCode), message.hashCode), text.hashCode),
        timestamp.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Notification')
          ..add('packageName', packageName)
          ..add('message', message)
          ..add('text', text)
          ..add('timestamp', timestamp))
        .toString();
  }
}

class NotificationBuilder
    implements Builder<Notification, NotificationBuilder> {
  _$Notification? _$v;

  String? _packageName;
  String? get packageName => _$this._packageName;
  set packageName(String? packageName) => _$this._packageName = packageName;

  String? _message;
  String? get message => _$this._message;
  set message(String? message) => _$this._message = message;

  String? _text;
  String? get text => _$this._text;
  set text(String? text) => _$this._text = text;

  DateTime? _timestamp;
  DateTime? get timestamp => _$this._timestamp;
  set timestamp(DateTime? timestamp) => _$this._timestamp = timestamp;

  NotificationBuilder();

  NotificationBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _packageName = $v.packageName;
      _message = $v.message;
      _text = $v.text;
      _timestamp = $v.timestamp;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Notification other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Notification;
  }

  @override
  void update(void Function(NotificationBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  _$Notification build() {
    final _$result = _$v ??
        new _$Notification._(
            packageName: BuiltValueNullFieldError.checkNotNull(
                packageName, 'Notification', 'packageName'),
            message: BuiltValueNullFieldError.checkNotNull(
                message, 'Notification', 'message'),
            text: BuiltValueNullFieldError.checkNotNull(
                text, 'Notification', 'text'),
            timestamp: BuiltValueNullFieldError.checkNotNull(
                timestamp, 'Notification', 'timestamp'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,deprecated_member_use_from_same_package,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
