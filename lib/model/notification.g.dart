// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<Notification> _$notificationSerializer =
    new _$NotificationSerializer();
Serializer<ProcessedNotification> _$processedNotificationSerializer =
    new _$ProcessedNotificationSerializer();

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

class _$ProcessedNotificationSerializer
    implements StructuredSerializer<ProcessedNotification> {
  @override
  final Iterable<Type> types = const [
    ProcessedNotification,
    _$ProcessedNotification
  ];
  @override
  final String wireName = 'ProcessedNotification';

  @override
  Iterable<Object?> serialize(
      Serializers serializers, ProcessedNotification object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'notification',
      serializers.serialize(object.notification,
          specifiedType: const FullType(Notification)),
      'regexMatches',
      serializers.serialize(object.regexMatches,
          specifiedType: const FullType(
              BuiltList, const [const FullType(NotificationMQTT)])),
    ];

    return result;
  }

  @override
  ProcessedNotification deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ProcessedNotificationBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'notification':
          result.notification.replace(serializers.deserialize(value,
              specifiedType: const FullType(Notification))! as Notification);
          break;
        case 'regexMatches':
          result.regexMatches.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(NotificationMQTT)]))!
              as BuiltList<Object?>);
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

class _$ProcessedNotification extends ProcessedNotification {
  @override
  final Notification notification;
  @override
  final BuiltList<NotificationMQTT> regexMatches;

  factory _$ProcessedNotification(
          [void Function(ProcessedNotificationBuilder)? updates]) =>
      (new ProcessedNotificationBuilder()..update(updates)).build();

  _$ProcessedNotification._(
      {required this.notification, required this.regexMatches})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        notification, 'ProcessedNotification', 'notification');
    BuiltValueNullFieldError.checkNotNull(
        regexMatches, 'ProcessedNotification', 'regexMatches');
  }

  @override
  ProcessedNotification rebuild(
          void Function(ProcessedNotificationBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProcessedNotificationBuilder toBuilder() =>
      new ProcessedNotificationBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProcessedNotification &&
        notification == other.notification &&
        regexMatches == other.regexMatches;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, notification.hashCode), regexMatches.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('ProcessedNotification')
          ..add('notification', notification)
          ..add('regexMatches', regexMatches))
        .toString();
  }
}

class ProcessedNotificationBuilder
    implements Builder<ProcessedNotification, ProcessedNotificationBuilder> {
  _$ProcessedNotification? _$v;

  NotificationBuilder? _notification;
  NotificationBuilder get notification =>
      _$this._notification ??= new NotificationBuilder();
  set notification(NotificationBuilder? notification) =>
      _$this._notification = notification;

  ListBuilder<NotificationMQTT>? _regexMatches;
  ListBuilder<NotificationMQTT> get regexMatches =>
      _$this._regexMatches ??= new ListBuilder<NotificationMQTT>();
  set regexMatches(ListBuilder<NotificationMQTT>? regexMatches) =>
      _$this._regexMatches = regexMatches;

  ProcessedNotificationBuilder();

  ProcessedNotificationBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _notification = $v.notification.toBuilder();
      _regexMatches = $v.regexMatches.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProcessedNotification other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ProcessedNotification;
  }

  @override
  void update(void Function(ProcessedNotificationBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  _$ProcessedNotification build() {
    _$ProcessedNotification _$result;
    try {
      _$result = _$v ??
          new _$ProcessedNotification._(
              notification: notification.build(),
              regexMatches: regexMatches.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'notification';
        notification.build();
        _$failedField = 'regexMatches';
        regexMatches.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'ProcessedNotification', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,deprecated_member_use_from_same_package,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
