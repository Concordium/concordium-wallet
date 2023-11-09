// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

TermsAndConditions _$TermsAndConditionsFromJson(Map<String, dynamic> json) {
  return _TermsAndConditions.fromJson(json);
}

/// @nodoc
mixin _$TermsAndConditions {
  Uri get url => throw _privateConstructorUsedError;
  String get version => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TermsAndConditionsCopyWith<TermsAndConditions> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TermsAndConditionsCopyWith<$Res> {
  factory $TermsAndConditionsCopyWith(TermsAndConditions value, $Res Function(TermsAndConditions) then) =
      _$TermsAndConditionsCopyWithImpl<$Res, TermsAndConditions>;
  @useResult
  $Res call({Uri url, String version});
}

/// @nodoc
class _$TermsAndConditionsCopyWithImpl<$Res, $Val extends TermsAndConditions> implements $TermsAndConditionsCopyWith<$Res> {
  _$TermsAndConditionsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? url = null,
    Object? version = null,
  }) {
    return _then(_value.copyWith(
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as Uri,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TermsAndConditionsImplCopyWith<$Res> implements $TermsAndConditionsCopyWith<$Res> {
  factory _$$TermsAndConditionsImplCopyWith(_$TermsAndConditionsImpl value, $Res Function(_$TermsAndConditionsImpl) then) =
      __$$TermsAndConditionsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Uri url, String version});
}

/// @nodoc
class __$$TermsAndConditionsImplCopyWithImpl<$Res> extends _$TermsAndConditionsCopyWithImpl<$Res, _$TermsAndConditionsImpl>
    implements _$$TermsAndConditionsImplCopyWith<$Res> {
  __$$TermsAndConditionsImplCopyWithImpl(_$TermsAndConditionsImpl _value, $Res Function(_$TermsAndConditionsImpl) _then) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? url = null,
    Object? version = null,
  }) {
    return _then(_$TermsAndConditionsImpl(
      null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as Uri,
      null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TermsAndConditionsImpl implements _TermsAndConditions {
  const _$TermsAndConditionsImpl(this.url, this.version);

  factory _$TermsAndConditionsImpl.fromJson(Map<String, dynamic> json) => _$$TermsAndConditionsImplFromJson(json);

  @override
  final Uri url;
  @override
  final String version;

  @override
  String toString() {
    return 'TermsAndConditions(url: $url, version: $version)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TermsAndConditionsImpl &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.version, version) || other.version == version));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, url, version);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TermsAndConditionsImplCopyWith<_$TermsAndConditionsImpl> get copyWith =>
      __$$TermsAndConditionsImplCopyWithImpl<_$TermsAndConditionsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TermsAndConditionsImplToJson(
      this,
    );
  }
}

abstract class _TermsAndConditions implements TermsAndConditions {
  const factory _TermsAndConditions(final Uri url, final String version) = _$TermsAndConditionsImpl;

  factory _TermsAndConditions.fromJson(Map<String, dynamic> json) = _$TermsAndConditionsImpl.fromJson;

  @override
  Uri get url;
  @override
  String get version;
  @override
  @JsonKey(ignore: true)
  _$$TermsAndConditionsImplCopyWith<_$TermsAndConditionsImpl> get copyWith => throw _privateConstructorUsedError;
}
