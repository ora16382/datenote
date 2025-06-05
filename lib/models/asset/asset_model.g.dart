// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AssetModel _$AssetModelFromJson(Map<String, dynamic> json) => _AssetModel(
  id: json['id'] as String,
  url: json['url'] as String?,
  type: $enumDecode(_$AssetTypeEnumMap, json['type']),
  createdAt: const TimestampConverter().fromJson(json['createdAt']),
  thumbnailUrl: json['thumbnailUrl'] as String?,
);

Map<String, dynamic> _$AssetModelToJson(_AssetModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'url': instance.url,
      'type': _$AssetTypeEnumMap[instance.type]!,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'thumbnailUrl': instance.thumbnailUrl,
    };

const _$AssetTypeEnumMap = {AssetType.image: 'image', AssetType.video: 'video'};
