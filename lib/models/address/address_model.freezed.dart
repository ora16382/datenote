// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'address_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AddressModel {

 String get id;// UUID
 String get address;// 기본 주소 (지번/도로명)
 String get detailAddress;// 상세 주소 (건물명, 호수 등)
 String get addressName;// 사용자가 설정한 주소 이름 (예: 집, 회사)
 double get latitude; double get longitude;@TimestampConverter() DateTime get createdAt;@TimestampConverter() DateTime get orderDate;
/// Create a copy of AddressModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AddressModelCopyWith<AddressModel> get copyWith => _$AddressModelCopyWithImpl<AddressModel>(this as AddressModel, _$identity);

  /// Serializes this AddressModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddressModel&&(identical(other.id, id) || other.id == id)&&(identical(other.address, address) || other.address == address)&&(identical(other.detailAddress, detailAddress) || other.detailAddress == detailAddress)&&(identical(other.addressName, addressName) || other.addressName == addressName)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.orderDate, orderDate) || other.orderDate == orderDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,address,detailAddress,addressName,latitude,longitude,createdAt,orderDate);

@override
String toString() {
  return 'AddressModel(id: $id, address: $address, detailAddress: $detailAddress, addressName: $addressName, latitude: $latitude, longitude: $longitude, createdAt: $createdAt, orderDate: $orderDate)';
}


}

/// @nodoc
abstract mixin class $AddressModelCopyWith<$Res>  {
  factory $AddressModelCopyWith(AddressModel value, $Res Function(AddressModel) _then) = _$AddressModelCopyWithImpl;
@useResult
$Res call({
 String id, String address, String detailAddress, String addressName, double latitude, double longitude,@TimestampConverter() DateTime createdAt,@TimestampConverter() DateTime orderDate
});




}
/// @nodoc
class _$AddressModelCopyWithImpl<$Res>
    implements $AddressModelCopyWith<$Res> {
  _$AddressModelCopyWithImpl(this._self, this._then);

  final AddressModel _self;
  final $Res Function(AddressModel) _then;

/// Create a copy of AddressModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? address = null,Object? detailAddress = null,Object? addressName = null,Object? latitude = null,Object? longitude = null,Object? createdAt = null,Object? orderDate = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,detailAddress: null == detailAddress ? _self.detailAddress : detailAddress // ignore: cast_nullable_to_non_nullable
as String,addressName: null == addressName ? _self.addressName : addressName // ignore: cast_nullable_to_non_nullable
as String,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,orderDate: null == orderDate ? _self.orderDate : orderDate // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _AddressModel implements AddressModel {
  const _AddressModel({required this.id, required this.address, required this.detailAddress, required this.addressName, required this.latitude, required this.longitude, @TimestampConverter() required this.createdAt, @TimestampConverter() required this.orderDate});
  factory _AddressModel.fromJson(Map<String, dynamic> json) => _$AddressModelFromJson(json);

@override final  String id;
// UUID
@override final  String address;
// 기본 주소 (지번/도로명)
@override final  String detailAddress;
// 상세 주소 (건물명, 호수 등)
@override final  String addressName;
// 사용자가 설정한 주소 이름 (예: 집, 회사)
@override final  double latitude;
@override final  double longitude;
@override@TimestampConverter() final  DateTime createdAt;
@override@TimestampConverter() final  DateTime orderDate;

/// Create a copy of AddressModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AddressModelCopyWith<_AddressModel> get copyWith => __$AddressModelCopyWithImpl<_AddressModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AddressModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AddressModel&&(identical(other.id, id) || other.id == id)&&(identical(other.address, address) || other.address == address)&&(identical(other.detailAddress, detailAddress) || other.detailAddress == detailAddress)&&(identical(other.addressName, addressName) || other.addressName == addressName)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.orderDate, orderDate) || other.orderDate == orderDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,address,detailAddress,addressName,latitude,longitude,createdAt,orderDate);

@override
String toString() {
  return 'AddressModel(id: $id, address: $address, detailAddress: $detailAddress, addressName: $addressName, latitude: $latitude, longitude: $longitude, createdAt: $createdAt, orderDate: $orderDate)';
}


}

/// @nodoc
abstract mixin class _$AddressModelCopyWith<$Res> implements $AddressModelCopyWith<$Res> {
  factory _$AddressModelCopyWith(_AddressModel value, $Res Function(_AddressModel) _then) = __$AddressModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String address, String detailAddress, String addressName, double latitude, double longitude,@TimestampConverter() DateTime createdAt,@TimestampConverter() DateTime orderDate
});




}
/// @nodoc
class __$AddressModelCopyWithImpl<$Res>
    implements _$AddressModelCopyWith<$Res> {
  __$AddressModelCopyWithImpl(this._self, this._then);

  final _AddressModel _self;
  final $Res Function(_AddressModel) _then;

/// Create a copy of AddressModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? address = null,Object? detailAddress = null,Object? addressName = null,Object? latitude = null,Object? longitude = null,Object? createdAt = null,Object? orderDate = null,}) {
  return _then(_AddressModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,detailAddress: null == detailAddress ? _self.detailAddress : detailAddress // ignore: cast_nullable_to_non_nullable
as String,addressName: null == addressName ? _self.addressName : addressName // ignore: cast_nullable_to_non_nullable
as String,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,orderDate: null == orderDate ? _self.orderDate : orderDate // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
