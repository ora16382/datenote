// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dating_history_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DatingHistoryModel _$DatingHistoryModelFromJson(Map<String, dynamic> json) =>
    _DatingHistoryModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      description: json['description'] as String,
      recommendPlanId: json['recommendPlanId'] as String?,
      mood: $enumDecode(_$MoodTypeEnumMap, json['mood']),
      isOpenToCommunity: json['isOpenToCommunity'] as bool,
      user:
          json['user'] == null
              ? null
              : UserModel.fromJson(json['user'] as Map<String, dynamic>),
      likesUserId:
          (json['likesUserId'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      assets:
          (json['assets'] as List<dynamic>?)
              ?.map((e) => AssetModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          const [],
      createdAt: const TimestampConverterNotNull().fromJson(json['createdAt']),
      modifiedAt: const TimestampConverterNotNull().fromJson(
        json['modifiedAt'],
      ),
      date: const TimestampConverterNotNull().fromJson(json['date']),
    );

Map<String, dynamic> _$DatingHistoryModelToJson(
  _DatingHistoryModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'description': instance.description,
  'recommendPlanId': instance.recommendPlanId,
  'mood': _$MoodTypeEnumMap[instance.mood]!,
  'isOpenToCommunity': instance.isOpenToCommunity,
  'user': instance.user?.toJson(),
  'likesUserId': instance.likesUserId,
  'assets': instance.assets.map((e) => e.toJson()).toList(),
  'tags': instance.tags,
  'createdAt': const TimestampConverterNotNull().toJson(instance.createdAt),
  'modifiedAt': const TimestampConverterNotNull().toJson(instance.modifiedAt),
  'date': const TimestampConverterNotNull().toJson(instance.date),
};

const _$MoodTypeEnumMap = {
  MoodType.happy: 'happy',
  MoodType.excited: 'excited',
  MoodType.calm: 'calm',
  MoodType.tired: 'tired',
  MoodType.sad: 'sad',
  MoodType.annoyed: 'annoyed',
  MoodType.angry: 'angry',
};
