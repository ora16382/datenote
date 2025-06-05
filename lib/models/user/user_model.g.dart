// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserModel _$UserModelFromJson(Map<String, dynamic> json) => _UserModel(
  uid: json['uid'] as String,
  email: json['email'] as String,
  displayName: json['displayName'] as String,
  ageGroup: ageGroupFromJson(json['ageGroup'] as String?),
  gender: genderFromJson(json['gender'] as String?),
  dateStyle: dateStyleFromJson(json['dateStyle'] as List?),
  region: regionFromJson(json['region'] as String?),
  createdAt: const TimestampConverter().fromJson(json['createdAt']),
);

Map<String, dynamic> _$UserModelToJson(_UserModel instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'email': instance.email,
      'displayName': instance.displayName,
      'ageGroup': ageGroupToJson(instance.ageGroup),
      'gender': genderToJson(instance.gender),
      'dateStyle': dateStyleToJson(instance.dateStyle),
      'region': regionToJson(instance.region),
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
    };
