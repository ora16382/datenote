// ignore_for_file: invalid_annotation_target

import 'package:datenote/constant/converter/timestamp_converter.dart';
import 'package:datenote/models/place/place_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../address/address_model.dart';

part 'recommend_plan_model.freezed.dart';
part 'recommend_plan_model.g.dart';

@freezed
abstract class RecommendPlanModel with _$RecommendPlanModel {
  @JsonSerializable(explicitToJson: true)
  const factory RecommendPlanModel({
    required String id, // UUID
    required String userId,
    @JsonKey(name: 'date_plan_title') required String title,
    @JsonKey(name: 'why_recommend_dating_plans') required String description,
    @JsonKey(name: 'date_places') required List<PlaceModel> places,
    required AddressModel baseAddress,
    @TimestampConverter() required DateTime date,
    @TimestampConverter() required DateTime createdAt,
    @TimestampConverter() required DateTime modifiedAt,
  }) = _RecommendPlanModel;

  factory RecommendPlanModel.fromJson(Map<String, dynamic> json) =>
      _$RecommendPlanModelFromJson(json);
}
