// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AddressModel _$AddressModelFromJson(Map<String, dynamic> json) =>
    _AddressModel(
      id: json['id'] as String,
      address: json['address'] as String,
      detailAddress: json['detailAddress'] as String,
      addressName: json['addressName'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      createdAt: const TimestampConverterNotNull().fromJson(json['createdAt']),
      orderDate: const TimestampConverterNotNull().fromJson(json['orderDate']),
    );

Map<String, dynamic> _$AddressModelToJson(_AddressModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'address': instance.address,
      'detailAddress': instance.detailAddress,
      'addressName': instance.addressName,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'createdAt': const TimestampConverterNotNull().toJson(instance.createdAt),
      'orderDate': const TimestampConverterNotNull().toJson(instance.orderDate),
    };
