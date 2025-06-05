// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dating_history_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DatingHistoryModel {

 String get id; String get userId; String get description; String? get recommendPlanId; MoodType get mood; bool get isOpenToCommunity; UserModel? get user; List<String> get likesUserId; List<AssetModel> get assets; List<String> get tags;@TimestampConverter() DateTime get createdAt;@TimestampConverter() DateTime get modifiedAt;@TimestampConverter() DateTime get date;
/// Create a copy of DatingHistoryModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DatingHistoryModelCopyWith<DatingHistoryModel> get copyWith => _$DatingHistoryModelCopyWithImpl<DatingHistoryModel>(this as DatingHistoryModel, _$identity);

  /// Serializes this DatingHistoryModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DatingHistoryModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.description, description) || other.description == description)&&(identical(other.recommendPlanId, recommendPlanId) || other.recommendPlanId == recommendPlanId)&&(identical(other.mood, mood) || other.mood == mood)&&(identical(other.isOpenToCommunity, isOpenToCommunity) || other.isOpenToCommunity == isOpenToCommunity)&&(identical(other.user, user) || other.user == user)&&const DeepCollectionEquality().equals(other.likesUserId, likesUserId)&&const DeepCollectionEquality().equals(other.assets, assets)&&const DeepCollectionEquality().equals(other.tags, tags)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.modifiedAt, modifiedAt) || other.modifiedAt == modifiedAt)&&(identical(other.date, date) || other.date == date));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,description,recommendPlanId,mood,isOpenToCommunity,user,const DeepCollectionEquality().hash(likesUserId),const DeepCollectionEquality().hash(assets),const DeepCollectionEquality().hash(tags),createdAt,modifiedAt,date);

@override
String toString() {
  return 'DatingHistoryModel(id: $id, userId: $userId, description: $description, recommendPlanId: $recommendPlanId, mood: $mood, isOpenToCommunity: $isOpenToCommunity, user: $user, likesUserId: $likesUserId, assets: $assets, tags: $tags, createdAt: $createdAt, modifiedAt: $modifiedAt, date: $date)';
}


}

/// @nodoc
abstract mixin class $DatingHistoryModelCopyWith<$Res>  {
  factory $DatingHistoryModelCopyWith(DatingHistoryModel value, $Res Function(DatingHistoryModel) _then) = _$DatingHistoryModelCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String description, String? recommendPlanId, MoodType mood, bool isOpenToCommunity, UserModel? user, List<String> likesUserId, List<AssetModel> assets, List<String> tags,@TimestampConverter() DateTime createdAt,@TimestampConverter() DateTime modifiedAt,@TimestampConverter() DateTime date
});


$UserModelCopyWith<$Res>? get user;

}
/// @nodoc
class _$DatingHistoryModelCopyWithImpl<$Res>
    implements $DatingHistoryModelCopyWith<$Res> {
  _$DatingHistoryModelCopyWithImpl(this._self, this._then);

  final DatingHistoryModel _self;
  final $Res Function(DatingHistoryModel) _then;

/// Create a copy of DatingHistoryModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? description = null,Object? recommendPlanId = freezed,Object? mood = null,Object? isOpenToCommunity = null,Object? user = freezed,Object? likesUserId = null,Object? assets = null,Object? tags = null,Object? createdAt = null,Object? modifiedAt = null,Object? date = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,recommendPlanId: freezed == recommendPlanId ? _self.recommendPlanId : recommendPlanId // ignore: cast_nullable_to_non_nullable
as String?,mood: null == mood ? _self.mood : mood // ignore: cast_nullable_to_non_nullable
as MoodType,isOpenToCommunity: null == isOpenToCommunity ? _self.isOpenToCommunity : isOpenToCommunity // ignore: cast_nullable_to_non_nullable
as bool,user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as UserModel?,likesUserId: null == likesUserId ? _self.likesUserId : likesUserId // ignore: cast_nullable_to_non_nullable
as List<String>,assets: null == assets ? _self.assets : assets // ignore: cast_nullable_to_non_nullable
as List<AssetModel>,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,modifiedAt: null == modifiedAt ? _self.modifiedAt : modifiedAt // ignore: cast_nullable_to_non_nullable
as DateTime,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of DatingHistoryModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserModelCopyWith<$Res>? get user {
    if (_self.user == null) {
    return null;
  }

  return $UserModelCopyWith<$Res>(_self.user!, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}


/// @nodoc

@JsonSerializable(explicitToJson: true)
class _DatingHistoryModel implements DatingHistoryModel {
  const _DatingHistoryModel({required this.id, required this.userId, required this.description, this.recommendPlanId, required this.mood, required this.isOpenToCommunity, this.user, final  List<String> likesUserId = const [], final  List<AssetModel> assets = const [], final  List<String> tags = const [], @TimestampConverter() required this.createdAt, @TimestampConverter() required this.modifiedAt, @TimestampConverter() required this.date}): _likesUserId = likesUserId,_assets = assets,_tags = tags;
  factory _DatingHistoryModel.fromJson(Map<String, dynamic> json) => _$DatingHistoryModelFromJson(json);

@override final  String id;
@override final  String userId;
@override final  String description;
@override final  String? recommendPlanId;
@override final  MoodType mood;
@override final  bool isOpenToCommunity;
@override final  UserModel? user;
 final  List<String> _likesUserId;
@override@JsonKey() List<String> get likesUserId {
  if (_likesUserId is EqualUnmodifiableListView) return _likesUserId;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_likesUserId);
}

 final  List<AssetModel> _assets;
@override@JsonKey() List<AssetModel> get assets {
  if (_assets is EqualUnmodifiableListView) return _assets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_assets);
}

 final  List<String> _tags;
@override@JsonKey() List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}

@override@TimestampConverter() final  DateTime createdAt;
@override@TimestampConverter() final  DateTime modifiedAt;
@override@TimestampConverter() final  DateTime date;

/// Create a copy of DatingHistoryModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DatingHistoryModelCopyWith<_DatingHistoryModel> get copyWith => __$DatingHistoryModelCopyWithImpl<_DatingHistoryModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DatingHistoryModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DatingHistoryModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.description, description) || other.description == description)&&(identical(other.recommendPlanId, recommendPlanId) || other.recommendPlanId == recommendPlanId)&&(identical(other.mood, mood) || other.mood == mood)&&(identical(other.isOpenToCommunity, isOpenToCommunity) || other.isOpenToCommunity == isOpenToCommunity)&&(identical(other.user, user) || other.user == user)&&const DeepCollectionEquality().equals(other._likesUserId, _likesUserId)&&const DeepCollectionEquality().equals(other._assets, _assets)&&const DeepCollectionEquality().equals(other._tags, _tags)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.modifiedAt, modifiedAt) || other.modifiedAt == modifiedAt)&&(identical(other.date, date) || other.date == date));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,description,recommendPlanId,mood,isOpenToCommunity,user,const DeepCollectionEquality().hash(_likesUserId),const DeepCollectionEquality().hash(_assets),const DeepCollectionEquality().hash(_tags),createdAt,modifiedAt,date);

@override
String toString() {
  return 'DatingHistoryModel(id: $id, userId: $userId, description: $description, recommendPlanId: $recommendPlanId, mood: $mood, isOpenToCommunity: $isOpenToCommunity, user: $user, likesUserId: $likesUserId, assets: $assets, tags: $tags, createdAt: $createdAt, modifiedAt: $modifiedAt, date: $date)';
}


}

/// @nodoc
abstract mixin class _$DatingHistoryModelCopyWith<$Res> implements $DatingHistoryModelCopyWith<$Res> {
  factory _$DatingHistoryModelCopyWith(_DatingHistoryModel value, $Res Function(_DatingHistoryModel) _then) = __$DatingHistoryModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String description, String? recommendPlanId, MoodType mood, bool isOpenToCommunity, UserModel? user, List<String> likesUserId, List<AssetModel> assets, List<String> tags,@TimestampConverter() DateTime createdAt,@TimestampConverter() DateTime modifiedAt,@TimestampConverter() DateTime date
});


@override $UserModelCopyWith<$Res>? get user;

}
/// @nodoc
class __$DatingHistoryModelCopyWithImpl<$Res>
    implements _$DatingHistoryModelCopyWith<$Res> {
  __$DatingHistoryModelCopyWithImpl(this._self, this._then);

  final _DatingHistoryModel _self;
  final $Res Function(_DatingHistoryModel) _then;

/// Create a copy of DatingHistoryModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? description = null,Object? recommendPlanId = freezed,Object? mood = null,Object? isOpenToCommunity = null,Object? user = freezed,Object? likesUserId = null,Object? assets = null,Object? tags = null,Object? createdAt = null,Object? modifiedAt = null,Object? date = null,}) {
  return _then(_DatingHistoryModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,recommendPlanId: freezed == recommendPlanId ? _self.recommendPlanId : recommendPlanId // ignore: cast_nullable_to_non_nullable
as String?,mood: null == mood ? _self.mood : mood // ignore: cast_nullable_to_non_nullable
as MoodType,isOpenToCommunity: null == isOpenToCommunity ? _self.isOpenToCommunity : isOpenToCommunity // ignore: cast_nullable_to_non_nullable
as bool,user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as UserModel?,likesUserId: null == likesUserId ? _self._likesUserId : likesUserId // ignore: cast_nullable_to_non_nullable
as List<String>,assets: null == assets ? _self._assets : assets // ignore: cast_nullable_to_non_nullable
as List<AssetModel>,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,modifiedAt: null == modifiedAt ? _self.modifiedAt : modifiedAt // ignore: cast_nullable_to_non_nullable
as DateTime,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of DatingHistoryModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserModelCopyWith<$Res>? get user {
    if (_self.user == null) {
    return null;
  }

  return $UserModelCopyWith<$Res>(_self.user!, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}

// dart format on
