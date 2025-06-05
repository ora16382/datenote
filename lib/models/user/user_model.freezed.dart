// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserModel {

 String get uid; String get email; String get displayName;@JsonKey(fromJson: ageGroupFromJson, toJson: ageGroupToJson) AgeGroup? get ageGroup;@JsonKey(fromJson: genderFromJson, toJson: genderToJson) Gender? get gender;@JsonKey(fromJson: dateStyleFromJson, toJson: dateStyleToJson) List<DateStyle>? get dateStyle;@JsonKey(fromJson: regionFromJson, toJson: regionToJson) Region? get region;@TimestampConverter() DateTime get createdAt;
/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserModelCopyWith<UserModel> get copyWith => _$UserModelCopyWithImpl<UserModel>(this as UserModel, _$identity);

  /// Serializes this UserModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserModel&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.email, email) || other.email == email)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.ageGroup, ageGroup) || other.ageGroup == ageGroup)&&(identical(other.gender, gender) || other.gender == gender)&&const DeepCollectionEquality().equals(other.dateStyle, dateStyle)&&(identical(other.region, region) || other.region == region)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uid,email,displayName,ageGroup,gender,const DeepCollectionEquality().hash(dateStyle),region,createdAt);

@override
String toString() {
  return 'UserModel(uid: $uid, email: $email, displayName: $displayName, ageGroup: $ageGroup, gender: $gender, dateStyle: $dateStyle, region: $region, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $UserModelCopyWith<$Res>  {
  factory $UserModelCopyWith(UserModel value, $Res Function(UserModel) _then) = _$UserModelCopyWithImpl;
@useResult
$Res call({
 String uid, String email, String displayName,@JsonKey(fromJson: ageGroupFromJson, toJson: ageGroupToJson) AgeGroup? ageGroup,@JsonKey(fromJson: genderFromJson, toJson: genderToJson) Gender? gender,@JsonKey(fromJson: dateStyleFromJson, toJson: dateStyleToJson) List<DateStyle>? dateStyle,@JsonKey(fromJson: regionFromJson, toJson: regionToJson) Region? region,@TimestampConverter() DateTime createdAt
});




}
/// @nodoc
class _$UserModelCopyWithImpl<$Res>
    implements $UserModelCopyWith<$Res> {
  _$UserModelCopyWithImpl(this._self, this._then);

  final UserModel _self;
  final $Res Function(UserModel) _then;

/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? uid = null,Object? email = null,Object? displayName = null,Object? ageGroup = freezed,Object? gender = freezed,Object? dateStyle = freezed,Object? region = freezed,Object? createdAt = null,}) {
  return _then(_self.copyWith(
uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,ageGroup: freezed == ageGroup ? _self.ageGroup : ageGroup // ignore: cast_nullable_to_non_nullable
as AgeGroup?,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as Gender?,dateStyle: freezed == dateStyle ? _self.dateStyle : dateStyle // ignore: cast_nullable_to_non_nullable
as List<DateStyle>?,region: freezed == region ? _self.region : region // ignore: cast_nullable_to_non_nullable
as Region?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _UserModel implements UserModel {
  const _UserModel({required this.uid, required this.email, required this.displayName, @JsonKey(fromJson: ageGroupFromJson, toJson: ageGroupToJson) this.ageGroup, @JsonKey(fromJson: genderFromJson, toJson: genderToJson) this.gender, @JsonKey(fromJson: dateStyleFromJson, toJson: dateStyleToJson) final  List<DateStyle>? dateStyle, @JsonKey(fromJson: regionFromJson, toJson: regionToJson) this.region, @TimestampConverter() required this.createdAt}): _dateStyle = dateStyle;
  factory _UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

@override final  String uid;
@override final  String email;
@override final  String displayName;
@override@JsonKey(fromJson: ageGroupFromJson, toJson: ageGroupToJson) final  AgeGroup? ageGroup;
@override@JsonKey(fromJson: genderFromJson, toJson: genderToJson) final  Gender? gender;
 final  List<DateStyle>? _dateStyle;
@override@JsonKey(fromJson: dateStyleFromJson, toJson: dateStyleToJson) List<DateStyle>? get dateStyle {
  final value = _dateStyle;
  if (value == null) return null;
  if (_dateStyle is EqualUnmodifiableListView) return _dateStyle;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey(fromJson: regionFromJson, toJson: regionToJson) final  Region? region;
@override@TimestampConverter() final  DateTime createdAt;

/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserModelCopyWith<_UserModel> get copyWith => __$UserModelCopyWithImpl<_UserModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserModel&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.email, email) || other.email == email)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.ageGroup, ageGroup) || other.ageGroup == ageGroup)&&(identical(other.gender, gender) || other.gender == gender)&&const DeepCollectionEquality().equals(other._dateStyle, _dateStyle)&&(identical(other.region, region) || other.region == region)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uid,email,displayName,ageGroup,gender,const DeepCollectionEquality().hash(_dateStyle),region,createdAt);

@override
String toString() {
  return 'UserModel(uid: $uid, email: $email, displayName: $displayName, ageGroup: $ageGroup, gender: $gender, dateStyle: $dateStyle, region: $region, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$UserModelCopyWith<$Res> implements $UserModelCopyWith<$Res> {
  factory _$UserModelCopyWith(_UserModel value, $Res Function(_UserModel) _then) = __$UserModelCopyWithImpl;
@override @useResult
$Res call({
 String uid, String email, String displayName,@JsonKey(fromJson: ageGroupFromJson, toJson: ageGroupToJson) AgeGroup? ageGroup,@JsonKey(fromJson: genderFromJson, toJson: genderToJson) Gender? gender,@JsonKey(fromJson: dateStyleFromJson, toJson: dateStyleToJson) List<DateStyle>? dateStyle,@JsonKey(fromJson: regionFromJson, toJson: regionToJson) Region? region,@TimestampConverter() DateTime createdAt
});




}
/// @nodoc
class __$UserModelCopyWithImpl<$Res>
    implements _$UserModelCopyWith<$Res> {
  __$UserModelCopyWithImpl(this._self, this._then);

  final _UserModel _self;
  final $Res Function(_UserModel) _then;

/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? uid = null,Object? email = null,Object? displayName = null,Object? ageGroup = freezed,Object? gender = freezed,Object? dateStyle = freezed,Object? region = freezed,Object? createdAt = null,}) {
  return _then(_UserModel(
uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,ageGroup: freezed == ageGroup ? _self.ageGroup : ageGroup // ignore: cast_nullable_to_non_nullable
as AgeGroup?,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as Gender?,dateStyle: freezed == dateStyle ? _self._dateStyle : dateStyle // ignore: cast_nullable_to_non_nullable
as List<DateStyle>?,region: freezed == region ? _self.region : region // ignore: cast_nullable_to_non_nullable
as Region?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
