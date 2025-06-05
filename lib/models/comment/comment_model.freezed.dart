// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'comment_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CommentModel {

 String get id; String get comment; String get userId; String? get parentUserId; CommentPageType get commentPageType; List<CommentModel> get replies; String get articleId;// 댓글이 달린 게시글 ID
 UserModel? get user;// 댓글 유저
 UserModel? get parentUser;// 부모 댓글 유저
 bool get isModify;@TimestampConverter() DateTime get createdAt;@TimestampConverter() DateTime get modifiedAt;
/// Create a copy of CommentModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CommentModelCopyWith<CommentModel> get copyWith => _$CommentModelCopyWithImpl<CommentModel>(this as CommentModel, _$identity);

  /// Serializes this CommentModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CommentModel&&(identical(other.id, id) || other.id == id)&&(identical(other.comment, comment) || other.comment == comment)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.parentUserId, parentUserId) || other.parentUserId == parentUserId)&&(identical(other.commentPageType, commentPageType) || other.commentPageType == commentPageType)&&const DeepCollectionEquality().equals(other.replies, replies)&&(identical(other.articleId, articleId) || other.articleId == articleId)&&(identical(other.user, user) || other.user == user)&&(identical(other.parentUser, parentUser) || other.parentUser == parentUser)&&(identical(other.isModify, isModify) || other.isModify == isModify)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.modifiedAt, modifiedAt) || other.modifiedAt == modifiedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,comment,userId,parentUserId,commentPageType,const DeepCollectionEquality().hash(replies),articleId,user,parentUser,isModify,createdAt,modifiedAt);

@override
String toString() {
  return 'CommentModel(id: $id, comment: $comment, userId: $userId, parentUserId: $parentUserId, commentPageType: $commentPageType, replies: $replies, articleId: $articleId, user: $user, parentUser: $parentUser, isModify: $isModify, createdAt: $createdAt, modifiedAt: $modifiedAt)';
}


}

/// @nodoc
abstract mixin class $CommentModelCopyWith<$Res>  {
  factory $CommentModelCopyWith(CommentModel value, $Res Function(CommentModel) _then) = _$CommentModelCopyWithImpl;
@useResult
$Res call({
 String id, String comment, String userId, String? parentUserId, CommentPageType commentPageType, List<CommentModel> replies, String articleId, UserModel? user, UserModel? parentUser, bool isModify,@TimestampConverter() DateTime createdAt,@TimestampConverter() DateTime modifiedAt
});


$UserModelCopyWith<$Res>? get user;$UserModelCopyWith<$Res>? get parentUser;

}
/// @nodoc
class _$CommentModelCopyWithImpl<$Res>
    implements $CommentModelCopyWith<$Res> {
  _$CommentModelCopyWithImpl(this._self, this._then);

  final CommentModel _self;
  final $Res Function(CommentModel) _then;

/// Create a copy of CommentModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? comment = null,Object? userId = null,Object? parentUserId = freezed,Object? commentPageType = null,Object? replies = null,Object? articleId = null,Object? user = freezed,Object? parentUser = freezed,Object? isModify = null,Object? createdAt = null,Object? modifiedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,comment: null == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,parentUserId: freezed == parentUserId ? _self.parentUserId : parentUserId // ignore: cast_nullable_to_non_nullable
as String?,commentPageType: null == commentPageType ? _self.commentPageType : commentPageType // ignore: cast_nullable_to_non_nullable
as CommentPageType,replies: null == replies ? _self.replies : replies // ignore: cast_nullable_to_non_nullable
as List<CommentModel>,articleId: null == articleId ? _self.articleId : articleId // ignore: cast_nullable_to_non_nullable
as String,user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as UserModel?,parentUser: freezed == parentUser ? _self.parentUser : parentUser // ignore: cast_nullable_to_non_nullable
as UserModel?,isModify: null == isModify ? _self.isModify : isModify // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,modifiedAt: null == modifiedAt ? _self.modifiedAt : modifiedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of CommentModel
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
}/// Create a copy of CommentModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserModelCopyWith<$Res>? get parentUser {
    if (_self.parentUser == null) {
    return null;
  }

  return $UserModelCopyWith<$Res>(_self.parentUser!, (value) {
    return _then(_self.copyWith(parentUser: value));
  });
}
}


/// @nodoc

@JsonSerializable(explicitToJson: true)
class _CommentModel implements CommentModel {
  const _CommentModel({required this.id, required this.comment, required this.userId, this.parentUserId, required this.commentPageType, final  List<CommentModel> replies = const [], required this.articleId, this.user, this.parentUser, this.isModify = false, @TimestampConverter() required this.createdAt, @TimestampConverter() required this.modifiedAt}): _replies = replies;
  factory _CommentModel.fromJson(Map<String, dynamic> json) => _$CommentModelFromJson(json);

@override final  String id;
@override final  String comment;
@override final  String userId;
@override final  String? parentUserId;
@override final  CommentPageType commentPageType;
 final  List<CommentModel> _replies;
@override@JsonKey() List<CommentModel> get replies {
  if (_replies is EqualUnmodifiableListView) return _replies;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_replies);
}

@override final  String articleId;
// 댓글이 달린 게시글 ID
@override final  UserModel? user;
// 댓글 유저
@override final  UserModel? parentUser;
// 부모 댓글 유저
@override@JsonKey() final  bool isModify;
@override@TimestampConverter() final  DateTime createdAt;
@override@TimestampConverter() final  DateTime modifiedAt;

/// Create a copy of CommentModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CommentModelCopyWith<_CommentModel> get copyWith => __$CommentModelCopyWithImpl<_CommentModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CommentModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CommentModel&&(identical(other.id, id) || other.id == id)&&(identical(other.comment, comment) || other.comment == comment)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.parentUserId, parentUserId) || other.parentUserId == parentUserId)&&(identical(other.commentPageType, commentPageType) || other.commentPageType == commentPageType)&&const DeepCollectionEquality().equals(other._replies, _replies)&&(identical(other.articleId, articleId) || other.articleId == articleId)&&(identical(other.user, user) || other.user == user)&&(identical(other.parentUser, parentUser) || other.parentUser == parentUser)&&(identical(other.isModify, isModify) || other.isModify == isModify)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.modifiedAt, modifiedAt) || other.modifiedAt == modifiedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,comment,userId,parentUserId,commentPageType,const DeepCollectionEquality().hash(_replies),articleId,user,parentUser,isModify,createdAt,modifiedAt);

@override
String toString() {
  return 'CommentModel(id: $id, comment: $comment, userId: $userId, parentUserId: $parentUserId, commentPageType: $commentPageType, replies: $replies, articleId: $articleId, user: $user, parentUser: $parentUser, isModify: $isModify, createdAt: $createdAt, modifiedAt: $modifiedAt)';
}


}

/// @nodoc
abstract mixin class _$CommentModelCopyWith<$Res> implements $CommentModelCopyWith<$Res> {
  factory _$CommentModelCopyWith(_CommentModel value, $Res Function(_CommentModel) _then) = __$CommentModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String comment, String userId, String? parentUserId, CommentPageType commentPageType, List<CommentModel> replies, String articleId, UserModel? user, UserModel? parentUser, bool isModify,@TimestampConverter() DateTime createdAt,@TimestampConverter() DateTime modifiedAt
});


@override $UserModelCopyWith<$Res>? get user;@override $UserModelCopyWith<$Res>? get parentUser;

}
/// @nodoc
class __$CommentModelCopyWithImpl<$Res>
    implements _$CommentModelCopyWith<$Res> {
  __$CommentModelCopyWithImpl(this._self, this._then);

  final _CommentModel _self;
  final $Res Function(_CommentModel) _then;

/// Create a copy of CommentModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? comment = null,Object? userId = null,Object? parentUserId = freezed,Object? commentPageType = null,Object? replies = null,Object? articleId = null,Object? user = freezed,Object? parentUser = freezed,Object? isModify = null,Object? createdAt = null,Object? modifiedAt = null,}) {
  return _then(_CommentModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,comment: null == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,parentUserId: freezed == parentUserId ? _self.parentUserId : parentUserId // ignore: cast_nullable_to_non_nullable
as String?,commentPageType: null == commentPageType ? _self.commentPageType : commentPageType // ignore: cast_nullable_to_non_nullable
as CommentPageType,replies: null == replies ? _self._replies : replies // ignore: cast_nullable_to_non_nullable
as List<CommentModel>,articleId: null == articleId ? _self.articleId : articleId // ignore: cast_nullable_to_non_nullable
as String,user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as UserModel?,parentUser: freezed == parentUser ? _self.parentUser : parentUser // ignore: cast_nullable_to_non_nullable
as UserModel?,isModify: null == isModify ? _self.isModify : isModify // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,modifiedAt: null == modifiedAt ? _self.modifiedAt : modifiedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of CommentModel
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
}/// Create a copy of CommentModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserModelCopyWith<$Res>? get parentUser {
    if (_self.parentUser == null) {
    return null;
  }

  return $UserModelCopyWith<$Res>(_self.parentUser!, (value) {
    return _then(_self.copyWith(parentUser: value));
  });
}
}

// dart format on
