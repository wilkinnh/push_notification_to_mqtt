// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_mqtt_rule.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<NotificationMQTTRule> _$notificationMQTTRuleSerializer =
    new _$NotificationMQTTRuleSerializer();

class _$NotificationMQTTRuleSerializer
    implements StructuredSerializer<NotificationMQTTRule> {
  @override
  final Iterable<Type> types = const [
    NotificationMQTTRule,
    _$NotificationMQTTRule
  ];
  @override
  final String wireName = 'NotificationMQTTRule';

  @override
  Iterable<Object?> serialize(
      Serializers serializers, NotificationMQTTRule object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'packageName',
      serializers.serialize(object.packageName,
          specifiedType: const FullType(String)),
      'publishTopic',
      serializers.serialize(object.publishTopic,
          specifiedType: const FullType(String)),
    ];
    Object? value;
    value = object.titleRegex;
    if (value != null) {
      result
        ..add('titleRegex')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.messageRegex;
    if (value != null) {
      result
        ..add('messageRegex')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.dataTemplate;
    if (value != null) {
      result
        ..add('dataTemplate')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  NotificationMQTTRule deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new NotificationMQTTRuleBuilder();

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
        case 'titleRegex':
          result.titleRegex = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'messageRegex':
          result.messageRegex = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'dataTemplate':
          result.dataTemplate = serializers.deserialize(value,
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

class _$NotificationMQTTRule extends NotificationMQTTRule {
  @override
  final String packageName;
  @override
  final String? titleRegex;
  @override
  final String? messageRegex;
  @override
  final String? dataTemplate;
  @override
  final String publishTopic;

  factory _$NotificationMQTTRule(
          [void Function(NotificationMQTTRuleBuilder)? updates]) =>
      (new NotificationMQTTRuleBuilder()..update(updates)).build();

  _$NotificationMQTTRule._(
      {required this.packageName,
      this.titleRegex,
      this.messageRegex,
      this.dataTemplate,
      required this.publishTopic})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        packageName, 'NotificationMQTTRule', 'packageName');
    BuiltValueNullFieldError.checkNotNull(
        publishTopic, 'NotificationMQTTRule', 'publishTopic');
  }

  @override
  NotificationMQTTRule rebuild(
          void Function(NotificationMQTTRuleBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  NotificationMQTTRuleBuilder toBuilder() =>
      new NotificationMQTTRuleBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is NotificationMQTTRule &&
        packageName == other.packageName &&
        titleRegex == other.titleRegex &&
        messageRegex == other.messageRegex &&
        dataTemplate == other.dataTemplate &&
        publishTopic == other.publishTopic;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc($jc($jc(0, packageName.hashCode), titleRegex.hashCode),
                messageRegex.hashCode),
            dataTemplate.hashCode),
        publishTopic.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('NotificationMQTTRule')
          ..add('packageName', packageName)
          ..add('titleRegex', titleRegex)
          ..add('messageRegex', messageRegex)
          ..add('dataTemplate', dataTemplate)
          ..add('publishTopic', publishTopic))
        .toString();
  }
}

class NotificationMQTTRuleBuilder
    implements Builder<NotificationMQTTRule, NotificationMQTTRuleBuilder> {
  _$NotificationMQTTRule? _$v;

  String? _packageName;
  String? get packageName => _$this._packageName;
  set packageName(String? packageName) => _$this._packageName = packageName;

  String? _titleRegex;
  String? get titleRegex => _$this._titleRegex;
  set titleRegex(String? titleRegex) => _$this._titleRegex = titleRegex;

  String? _messageRegex;
  String? get messageRegex => _$this._messageRegex;
  set messageRegex(String? messageRegex) => _$this._messageRegex = messageRegex;

  String? _dataTemplate;
  String? get dataTemplate => _$this._dataTemplate;
  set dataTemplate(String? dataTemplate) => _$this._dataTemplate = dataTemplate;

  String? _publishTopic;
  String? get publishTopic => _$this._publishTopic;
  set publishTopic(String? publishTopic) => _$this._publishTopic = publishTopic;

  NotificationMQTTRuleBuilder();

  NotificationMQTTRuleBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _packageName = $v.packageName;
      _titleRegex = $v.titleRegex;
      _messageRegex = $v.messageRegex;
      _dataTemplate = $v.dataTemplate;
      _publishTopic = $v.publishTopic;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(NotificationMQTTRule other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$NotificationMQTTRule;
  }

  @override
  void update(void Function(NotificationMQTTRuleBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  _$NotificationMQTTRule build() {
    final _$result = _$v ??
        new _$NotificationMQTTRule._(
            packageName: BuiltValueNullFieldError.checkNotNull(
                packageName, 'NotificationMQTTRule', 'packageName'),
            titleRegex: titleRegex,
            messageRegex: messageRegex,
            dataTemplate: dataTemplate,
            publishTopic: BuiltValueNullFieldError.checkNotNull(
                publishTopic, 'NotificationMQTTRule', 'publishTopic'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,deprecated_member_use_from_same_package,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
