// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'asset_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AssetModel {

 String get id; String? get url;/// 기본적으로 enum은 json_serializable에서 자동 직렬화/역직렬화가 된다.
/// enum을 커스텀 문자열로 매핑하고 싶다면 → @JsonKey(fromJson: ..., toJson: ...)으로 명시해줘야 한다.
 AssetType get type;@TimestampConverter() DateTime get createdAt; String? get thumbnailUrl;
/// Create a copy of AssetModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AssetModelCopyWith<AssetModel> get copyWith => _$AssetModelCopyWithImpl<AssetModel>(this as AssetModel, _$identity);

  /// Serializes this AssetModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AssetModel&&(identical(other.id, id) || other.id == id)&&(identical(other.url, url) || other.url == url)&&(identical(other.type, type) || other.type == type)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,url,type,createdAt,thumbnailUrl);

@override
String toString() {
  return 'AssetModel(id: $id, url: $url, type: $type, createdAt: $createdAt, thumbnailUrl: $thumbnailUrl)';
}


}

/// @nodoc
abstract mixin class $AssetModelCopyWith<$Res>  {
  factory $AssetModelCopyWith(AssetModel value, $Res Function(AssetModel) _then) = _$AssetModelCopyWithImpl;
@useResult
$Res call({
 String id, String? url, AssetType type,@TimestampConverter() DateTime createdAt, String? thumbnailUrl
});




}
/// @nodoc
class _$AssetModelCopyWithImpl<$Res>
    implements $AssetModelCopyWith<$Res> {
  _$AssetModelCopyWithImpl(this._self, this._then);

  final AssetModel _self;
  final $Res Function(AssetModel) _then;

/// Create a copy of AssetModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? url = freezed,Object? type = null,Object? createdAt = null,Object? thumbnailUrl = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as AssetType,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,thumbnailUrl: freezed == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _AssetModel implements AssetModel {
  const _AssetModel({required this.id, this.url, required this.type, @TimestampConverter() required this.createdAt, this.thumbnailUrl});
  factory _AssetModel.fromJson(Map<String, dynamic> json) => _$AssetModelFromJson(json);

@override final  String id;
@override final  String? url;
/// 기본적으로 enum은 json_serializable에서 자동 직렬화/역직렬화가 된다.
/// enum을 커스텀 문자열로 매핑하고 싶다면 → @JsonKey(fromJson: ..., toJson: ...)으로 명시해줘야 한다.
@override final  AssetType type;
@override@TimestampConverter() final  DateTime createdAt;
@override final  String? thumbnailUrl;

/// Create a copy of AssetModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AssetModelCopyWith<_AssetModel> get copyWith => __$AssetModelCopyWithImpl<_AssetModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AssetModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AssetModel&&(identical(other.id, id) || other.id == id)&&(identical(other.url, url) || other.url == url)&&(identical(other.type, type) || other.type == type)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,url,type,createdAt,thumbnailUrl);

@override
String toString() {
  return 'AssetModel(id: $id, url: $url, type: $type, createdAt: $createdAt, thumbnailUrl: $thumbnailUrl)';
}


}

/// @nodoc
abstract mixin class _$AssetModelCopyWith<$Res> implements $AssetModelCopyWith<$Res> {
  factory _$AssetModelCopyWith(_AssetModel value, $Res Function(_AssetModel) _then) = __$AssetModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String? url, AssetType type,@TimestampConverter() DateTime createdAt, String? thumbnailUrl
});




}
/// @nodoc
class __$AssetModelCopyWithImpl<$Res>
    implements _$AssetModelCopyWith<$Res> {
  __$AssetModelCopyWithImpl(this._self, this._then);

  final _AssetModel _self;
  final $Res Function(_AssetModel) _then;

/// Create a copy of AssetModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? url = freezed,Object? type = null,Object? createdAt = null,Object? thumbnailUrl = freezed,}) {
  return _then(_AssetModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as AssetType,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,thumbnailUrl: freezed == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
