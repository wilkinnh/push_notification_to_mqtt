// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_mqtt.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<NotificationMQTT> _$notificationMQTTSerializer =
    new _$NotificationMQTTSerializer();

class _$NotificationMQTTSerializer
    implements StructuredSerializer<NotificationMQTT> {
  @override
  final Iterable<Type> types = const [NotificationMQTT, _$NotificationMQTT];
  @override
  final String wireName = 'NotificationMQTT';

  @override
  Iterable<Object?> serialize(Serializers serializers, NotificationMQTT object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'packageName',
      serializers.serialize(object.packageName,
          specifiedType: const FullType(String)),
      'regex',
      serializers.serialize(object.regex,
          specifiedType: const FullType(String)),
      'regexMatch',
      serializers.serialize(object.regexMatch,
          specifiedType: const FullType(String)),
      'publishTopic',
      serializers.serialize(object.publishTopic,
          specifiedType: const FullType(String)),
    ];
    Object? value;
    value = object.dataRegex;
    if (value != null) {
      result
        ..add('dataRegex')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  NotificationMQTT deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new NotificationMQTTBuilder();

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
        case 'regex':
          result.regex = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'regexMatch':
          result.regexMatch = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'dataRegex':
          result.dataRegex = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'publishTopic':
          result.publishTopic = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$NotificationMQTT extends NotificationMQTT {
  @override
  final String packageName;
  @override
  final String regex;
  @override
  final String regexMatch;
  @override
  final String? dataRegex;
  @override
  final String publishTopic;

  factory _$NotificationMQTT(
          [void Function(NotificationMQTTBuilder)? updates]) =>
      (new NotificationMQTTBuilder()..update(updates)).build();

  _$NotificationMQTT._(
      {required this.packageName,
      required this.regex,
      required this.regexMatch,
      this.dataRegex,
      required this.publishTopic})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        packageName, 'NotificationMQTT', 'packageName');
    BuiltValueNullFieldError.checkNotNull(regex, 'NotificationMQTT', 'regex');
    BuiltValueNullFieldError.checkNotNull(
        regexMatch, 'NotificationMQTT', 'regexMatch');
    BuiltValueNullFieldError.checkNotNull(
        publishTopic, 'NotificationMQTT', 'publishTopic');
  }

  @override
  NotificationMQTT rebuild(void Function(NotificationMQTTBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  NotificationMQTTBuilder toBuilder() =>
      new NotificationMQTTBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is NotificationMQTT &&
        packageName == other.packageName &&
        regex == other.regex &&
        regexMatch == other.regexMatch &&
        dataRegex == other.dataRegex &&
        publishTopic == other.publishTopic;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc($jc($jc(0, packageName.hashCode), regex.hashCode),
                regexMatch.hashCode),
            dataRegex.hashCode),
        publishTopic.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('NotificationMQTT')
          ..add('packageName', packageName)
          ..add('regex', regex)
          ..add('regexMatch', regexMatch)
          ..add('dataRegex', dataRegex)
          ..add('publishTopic', publishTopic))
        .toString();
  }
}

class NotificationMQTTBuilder
    implements Builder<NotificationMQTT, NotificationMQTTBuilder> {
  _$NotificationMQTT? _$v;

  String? _packageName;
  String? get packageName => _$this._packageName;
  set packageName(String? packageName) => _$this._packageName = packageName;

  String? _regex;
  String? get regex => _$this._regex;
  set regex(String? regex) => _$this._regex = regex;

  String? _regexMatch;
  String? get regexMatch => _$this._regexMatch;
  set regexMatch(String? regexMatch) => _$this._regexMatch = regexMatch;

  String? _dataRegex;
  String? get dataRegex => _$this._dataRegex;
  set dataRegex(String? dataRegex) => _$this._dataRegex = dataRegex;

  String? _publishTopic;
  String? get publishTopic => _$this._publishTopic;
  set publishTopic(String? publishTopic) => _$this._publishTopic = publishTopic;

  NotificationMQTTBuilder();

  NotificationMQTTBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _packageName = $v.packageName;
      _regex = $v.regex;
      _regexMatch = $v.regexMatch;
      _dataRegex = $v.dataRegex;
      _publishTopic = $v.publishTopic;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(NotificationMQTT other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$NotificationMQTT;
  }

  @override
  void update(void Function(NotificationMQTTBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  _$NotificationMQTT build() {
    final _$result = _$v ??
        new _$NotificationMQTT._(
            packageName: BuiltValueNullFieldError.checkNotNull(
                packageName, 'NotificationMQTT', 'packageName'),
            regex: BuiltValueNullFieldError.checkNotNull(
                regex, 'NotificationMQTT', 'regex'),
            regexMatch: BuiltValueNullFieldError.checkNotNull(
                regexMatch, 'NotificationMQTT', 'regexMatch'),
            dataRegex: dataRegex,
            publishTopic: BuiltValueNullFieldError.checkNotNull(
                publishTopic, 'NotificationMQTT', 'publishTopic'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,deprecated_member_use_from_same_package,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
