// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PlaceModel _$PlaceModelFromJson(Map<String, dynamic> json) => _PlaceModel(
  id: json['id'] as String,
  place_name: json['place_name'] as String,
  category_group_code: json['category_group_code'] as String,
  category_group_name: json['category_group_name'] as String,
  category_name: json['category_name'] as String,
  road_address_name: json['road_address_name'] as String,
  address_name: json['address_name'] as String,
  x: json['x'] as String,
  y: json['y'] as String,
  place_url: json['place_url'] as String,
  phone: json['phone'] as String?,
  distance: json['distance'] as String?,
  index: (json['index'] as num?)?.toInt(),
);

Map<String, dynamic> _$PlaceModelToJson(_PlaceModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'place_name': instance.place_name,
      'category_group_code': instance.category_group_code,
      'category_group_name': instance.category_group_name,
      'category_name': instance.category_name,
      'road_address_name': instance.road_address_name,
      'address_name': instance.address_name,
      'x': instance.x,
      'y': instance.y,
      'place_url': instance.place_url,
      'phone': instance.phone,
      'distance': instance.distance,
      'index': instance.index,
    };
