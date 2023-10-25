// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'built_value_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<TermsAndConditionsV2> _$termsAndConditionsV2Serializer =
    new _$TermsAndConditionsV2Serializer();

class _$TermsAndConditionsV2Serializer
    implements StructuredSerializer<TermsAndConditionsV2> {
  @override
  final Iterable<Type> types = const [
    TermsAndConditionsV2,
    _$TermsAndConditionsV2
  ];
  @override
  final String wireName = 'TermsAndConditionsV2';

  @override
  Iterable<Object?> serialize(
      Serializers serializers, TermsAndConditionsV2 object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'url',
      serializers.serialize(object.url, specifiedType: const FullType(Uri)),
      'version',
      serializers.serialize(object.version,
          specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  TermsAndConditionsV2 deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new TermsAndConditionsV2Builder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'url':
          result.url = serializers.deserialize(value,
              specifiedType: const FullType(Uri))! as Uri;
          break;
        case 'version':
          result.version = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
      }
    }

    return result.build();
  }
}

class _$TermsAndConditionsV2 extends TermsAndConditionsV2 {
  @override
  final Uri url;
  @override
  final String version;

  factory _$TermsAndConditionsV2(
          [void Function(TermsAndConditionsV2Builder)? updates]) =>
      (new TermsAndConditionsV2Builder()..update(updates))._build();

  _$TermsAndConditionsV2._({required this.url, required this.version})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(url, r'TermsAndConditionsV2', 'url');
    BuiltValueNullFieldError.checkNotNull(
        version, r'TermsAndConditionsV2', 'version');
  }

  @override
  TermsAndConditionsV2 rebuild(
          void Function(TermsAndConditionsV2Builder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TermsAndConditionsV2Builder toBuilder() =>
      new TermsAndConditionsV2Builder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TermsAndConditionsV2 &&
        url == other.url &&
        version == other.version;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, url.hashCode);
    _$hash = $jc(_$hash, version.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TermsAndConditionsV2')
          ..add('url', url)
          ..add('version', version))
        .toString();
  }
}

class TermsAndConditionsV2Builder
    implements Builder<TermsAndConditionsV2, TermsAndConditionsV2Builder> {
  _$TermsAndConditionsV2? _$v;

  Uri? _url;
  Uri? get url => _$this._url;
  set url(Uri? url) => _$this._url = url;

  String? _version;
  String? get version => _$this._version;
  set version(String? version) => _$this._version = version;

  TermsAndConditionsV2Builder();

  TermsAndConditionsV2Builder get _$this {
    final $v = _$v;
    if ($v != null) {
      _url = $v.url;
      _version = $v.version;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TermsAndConditionsV2 other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$TermsAndConditionsV2;
  }

  @override
  void update(void Function(TermsAndConditionsV2Builder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TermsAndConditionsV2 build() => _build();

  _$TermsAndConditionsV2 _build() {
    final _$result = _$v ??
        new _$TermsAndConditionsV2._(
            url: BuiltValueNullFieldError.checkNotNull(
                url, r'TermsAndConditionsV2', 'url'),
            version: BuiltValueNullFieldError.checkNotNull(
                version, r'TermsAndConditionsV2', 'version'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
