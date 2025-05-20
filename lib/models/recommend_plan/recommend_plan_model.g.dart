// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recommend_plan_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RecommendPlanModel _$RecommendPlanModelFromJson(Map<String, dynamic> json) =>
    _RecommendPlanModel(
      id: json['id'] as String,
      title: json['date_plan_title'] as String,
      description: json['why_recommend_dating_plans'] as String,
      places:
          (json['date_places'] as List<dynamic>)
              .map((e) => PlaceModel.fromJson(e as Map<String, dynamic>))
              .toList(),
      baseAddress: AddressModel.fromJson(
        json['baseAddress'] as Map<String, dynamic>,
      ),
      date: const TimestampConverterNotNull().fromJson(json['date']),
      createdAt: const TimestampConverterNotNull().fromJson(json['createdAt']),
      modifiedAt: const TimestampConverterNotNull().fromJson(
        json['modifiedAt'],
      ),
    );

Map<String, dynamic> _$RecommendPlanModelToJson(
  _RecommendPlanModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'date_plan_title': instance.title,
  'why_recommend_dating_plans': instance.description,
  'date_places': instance.places.map((e) => e.toJson()).toList(),
  'baseAddress': instance.baseAddress.toJson(),
  'date': const TimestampConverterNotNull().toJson(instance.date),
  'createdAt': const TimestampConverterNotNull().toJson(instance.createdAt),
  'modifiedAt': const TimestampConverterNotNull().toJson(instance.modifiedAt),
};
