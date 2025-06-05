import 'package:datenote/constant/enum/gender.dart';
import 'package:datenote/constant/enum/region.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get/get_utils/get_utils.dart';

import '../../constant/converter/timestamp_converter.dart';
import '../../constant/enum/age_group.dart';
import '../../constant/enum/date_style.dart';

part 'user_model.freezed.dart';

part 'user_model.g.dart';

@freezed
abstract class UserModel with _$UserModel {
  const factory UserModel({
    required String uid,
    required String email,
    required String displayName,
    @JsonKey(fromJson: ageGroupFromJson, toJson: ageGroupToJson)
    AgeGroup? ageGroup,
    @JsonKey(fromJson: genderFromJson, toJson: genderToJson) Gender? gender,
    @JsonKey(fromJson: dateStyleFromJson, toJson: dateStyleToJson)
    List<DateStyle>? dateStyle,
    @JsonKey(fromJson: regionFromJson, toJson: regionToJson) Region? region,
    @TimestampConverter() required DateTime createdAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}

AgeGroup? ageGroupFromJson(String? value) {
  return AgeGroup.values.firstWhereOrNull((e) => e.name == value);
}

String? ageGroupToJson(AgeGroup? value) => value?.name;

Gender? genderFromJson(String? value) {
  return Gender.values.firstWhereOrNull((e) => e.name == value);
}

String? genderToJson(Gender? value) => value?.name;

// from JSON (문자열 리스트 → enum 리스트)
List<DateStyle>? dateStyleFromJson(List<dynamic>? list) {
  return list
      ?.map((e) => DateStyle.values.firstWhereOrNull((g) => g.name == e))
      .whereType<DateStyle>()
      .toList();
}

// to JSON (enum 리스트 → 문자열 리스트)
List<String>? dateStyleToJson(List<DateStyle>? dateStyles) {
  return dateStyles?.map((g) => g.name).toList();
}

Region? regionFromJson(String? value) {
  return Region.values.firstWhereOrNull((e) => e.name == value);
}

String? regionToJson(Region? value) => value?.name;
