// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'place_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PlaceModel {

 String get id; String get place_name; String get category_group_code; String get category_group_name; String get category_name; String get road_address_name; String get address_name; String get x; String get y; String get place_url; String? get phone; String? get distance; int? get index;
/// Create a copy of PlaceModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlaceModelCopyWith<PlaceModel> get copyWith => _$PlaceModelCopyWithImpl<PlaceModel>(this as PlaceModel, _$identity);

  /// Serializes this PlaceModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlaceModel&&(identical(other.id, id) || other.id == id)&&(identical(other.place_name, place_name) || other.place_name == place_name)&&(identical(other.category_group_code, category_group_code) || other.category_group_code == category_group_code)&&(identical(other.category_group_name, category_group_name) || other.category_group_name == category_group_name)&&(identical(other.category_name, category_name) || other.category_name == category_name)&&(identical(other.road_address_name, road_address_name) || other.road_address_name == road_address_name)&&(identical(other.address_name, address_name) || other.address_name == address_name)&&(identical(other.x, x) || other.x == x)&&(identical(other.y, y) || other.y == y)&&(identical(other.place_url, place_url) || other.place_url == place_url)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.distance, distance) || other.distance == distance)&&(identical(other.index, index) || other.index == index));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,place_name,category_group_code,category_group_name,category_name,road_address_name,address_name,x,y,place_url,phone,distance,index);

@override
String toString() {
  return 'PlaceModel(id: $id, place_name: $place_name, category_group_code: $category_group_code, category_group_name: $category_group_name, category_name: $category_name, road_address_name: $road_address_name, address_name: $address_name, x: $x, y: $y, place_url: $place_url, phone: $phone, distance: $distance, index: $index)';
}


}

/// @nodoc
abstract mixin class $PlaceModelCopyWith<$Res>  {
  factory $PlaceModelCopyWith(PlaceModel value, $Res Function(PlaceModel) _then) = _$PlaceModelCopyWithImpl;
@useResult
$Res call({
 String id, String place_name, String category_group_code, String category_group_name, String category_name, String road_address_name, String address_name, String x, String y, String place_url, String? phone, String? distance, int? index
});




}
/// @nodoc
class _$PlaceModelCopyWithImpl<$Res>
    implements $PlaceModelCopyWith<$Res> {
  _$PlaceModelCopyWithImpl(this._self, this._then);

  final PlaceModel _self;
  final $Res Function(PlaceModel) _then;

/// Create a copy of PlaceModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? place_name = null,Object? category_group_code = null,Object? category_group_name = null,Object? category_name = null,Object? road_address_name = null,Object? address_name = null,Object? x = null,Object? y = null,Object? place_url = null,Object? phone = freezed,Object? distance = freezed,Object? index = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,place_name: null == place_name ? _self.place_name : place_name // ignore: cast_nullable_to_non_nullable
as String,category_group_code: null == category_group_code ? _self.category_group_code : category_group_code // ignore: cast_nullable_to_non_nullable
as String,category_group_name: null == category_group_name ? _self.category_group_name : category_group_name // ignore: cast_nullable_to_non_nullable
as String,category_name: null == category_name ? _self.category_name : category_name // ignore: cast_nullable_to_non_nullable
as String,road_address_name: null == road_address_name ? _self.road_address_name : road_address_name // ignore: cast_nullable_to_non_nullable
as String,address_name: null == address_name ? _self.address_name : address_name // ignore: cast_nullable_to_non_nullable
as String,x: null == x ? _self.x : x // ignore: cast_nullable_to_non_nullable
as String,y: null == y ? _self.y : y // ignore: cast_nullable_to_non_nullable
as String,place_url: null == place_url ? _self.place_url : place_url // ignore: cast_nullable_to_non_nullable
as String,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,distance: freezed == distance ? _self.distance : distance // ignore: cast_nullable_to_non_nullable
as String?,index: freezed == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _PlaceModel implements PlaceModel {
  const _PlaceModel({required this.id, required this.place_name, required this.category_group_code, required this.category_group_name, required this.category_name, required this.road_address_name, required this.address_name, required this.x, required this.y, required this.place_url, this.phone, this.distance, this.index});
  factory _PlaceModel.fromJson(Map<String, dynamic> json) => _$PlaceModelFromJson(json);

@override final  String id;
@override final  String place_name;
@override final  String category_group_code;
@override final  String category_group_name;
@override final  String category_name;
@override final  String road_address_name;
@override final  String address_name;
@override final  String x;
@override final  String y;
@override final  String place_url;
@override final  String? phone;
@override final  String? distance;
@override final  int? index;

/// Create a copy of PlaceModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlaceModelCopyWith<_PlaceModel> get copyWith => __$PlaceModelCopyWithImpl<_PlaceModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlaceModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlaceModel&&(identical(other.id, id) || other.id == id)&&(identical(other.place_name, place_name) || other.place_name == place_name)&&(identical(other.category_group_code, category_group_code) || other.category_group_code == category_group_code)&&(identical(other.category_group_name, category_group_name) || other.category_group_name == category_group_name)&&(identical(other.category_name, category_name) || other.category_name == category_name)&&(identical(other.road_address_name, road_address_name) || other.road_address_name == road_address_name)&&(identical(other.address_name, address_name) || other.address_name == address_name)&&(identical(other.x, x) || other.x == x)&&(identical(other.y, y) || other.y == y)&&(identical(other.place_url, place_url) || other.place_url == place_url)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.distance, distance) || other.distance == distance)&&(identical(other.index, index) || other.index == index));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,place_name,category_group_code,category_group_name,category_name,road_address_name,address_name,x,y,place_url,phone,distance,index);

@override
String toString() {
  return 'PlaceModel(id: $id, place_name: $place_name, category_group_code: $category_group_code, category_group_name: $category_group_name, category_name: $category_name, road_address_name: $road_address_name, address_name: $address_name, x: $x, y: $y, place_url: $place_url, phone: $phone, distance: $distance, index: $index)';
}


}

/// @nodoc
abstract mixin class _$PlaceModelCopyWith<$Res> implements $PlaceModelCopyWith<$Res> {
  factory _$PlaceModelCopyWith(_PlaceModel value, $Res Function(_PlaceModel) _then) = __$PlaceModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String place_name, String category_group_code, String category_group_name, String category_name, String road_address_name, String address_name, String x, String y, String place_url, String? phone, String? distance, int? index
});




}
/// @nodoc
class __$PlaceModelCopyWithImpl<$Res>
    implements _$PlaceModelCopyWith<$Res> {
  __$PlaceModelCopyWithImpl(this._self, this._then);

  final _PlaceModel _self;
  final $Res Function(_PlaceModel) _then;

/// Create a copy of PlaceModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? place_name = null,Object? category_group_code = null,Object? category_group_name = null,Object? category_name = null,Object? road_address_name = null,Object? address_name = null,Object? x = null,Object? y = null,Object? place_url = null,Object? phone = freezed,Object? distance = freezed,Object? index = freezed,}) {
  return _then(_PlaceModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,place_name: null == place_name ? _self.place_name : place_name // ignore: cast_nullable_to_non_nullable
as String,category_group_code: null == category_group_code ? _self.category_group_code : category_group_code // ignore: cast_nullable_to_non_nullable
as String,category_group_name: null == category_group_name ? _self.category_group_name : category_group_name // ignore: cast_nullable_to_non_nullable
as String,category_name: null == category_name ? _self.category_name : category_name // ignore: cast_nullable_to_non_nullable
as String,road_address_name: null == road_address_name ? _self.road_address_name : road_address_name // ignore: cast_nullable_to_non_nullable
as String,address_name: null == address_name ? _self.address_name : address_name // ignore: cast_nullable_to_non_nullable
as String,x: null == x ? _self.x : x // ignore: cast_nullable_to_non_nullable
as String,y: null == y ? _self.y : y // ignore: cast_nullable_to_non_nullable
as String,place_url: null == place_url ? _self.place_url : place_url // ignore: cast_nullable_to_non_nullable
as String,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,distance: freezed == distance ? _self.distance : distance // ignore: cast_nullable_to_non_nullable
as String?,index: freezed == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
