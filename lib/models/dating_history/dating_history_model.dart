// ignore_for_file: invalid_annotation_target

import 'package:datenote/constant/converter/timestamp_converter.dart';
import 'package:datenote/constant/enum/mood_type.dart';
import 'package:datenote/models/asset/asset_model.dart';
import 'package:datenote/models/user/user_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'dating_history_model.freezed.dart';
part 'dating_history_model.g.dart';


@freezed
abstract class DatingHistoryModel with _$DatingHistoryModel {
  /// null 필드도 추가하고 싶다면, includeIfNull: true 추가
  @JsonSerializable(explicitToJson: true)
  const factory DatingHistoryModel({
    required String id,
    required String userId,
    required String description,
    String? recommendPlanId,
    required MoodType mood,
    required bool isOpenToCommunity,
    UserModel? user,
    @Default([]) List<String> likesUserId,
    @Default([]) List<AssetModel> assets,
    @Default([]) List<String> tags,
    @TimestampConverterNotNull() required DateTime createdAt,
    @TimestampConverterNotNull() required DateTime modifiedAt,
    @TimestampConverterNotNull() required DateTime date,
  }) = _DatingHistoryModel;

  factory DatingHistoryModel.fromJson(Map<String, dynamic> json) => _$DatingHistoryModelFromJson(json);
}

