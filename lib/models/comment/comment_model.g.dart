// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CommentModel _$CommentModelFromJson(Map<String, dynamic> json) =>
    _CommentModel(
      id: json['id'] as String,
      comment: json['comment'] as String,
      userId: json['userId'] as String,
      parentUserId: json['parentUserId'] as String?,
      commentPageType: $enumDecode(
        _$CommentPageTypeEnumMap,
        json['commentPageType'],
      ),
      replies:
          (json['replies'] as List<dynamic>?)
              ?.map((e) => CommentModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      articleId: json['articleId'] as String,
      user:
          json['user'] == null
              ? null
              : UserModel.fromJson(json['user'] as Map<String, dynamic>),
      parentUser:
          json['parentUser'] == null
              ? null
              : UserModel.fromJson(json['parentUser'] as Map<String, dynamic>),
      isModify: json['isModify'] as bool? ?? false,
      createdAt: const TimestampConverter().fromJson(json['createdAt']),
      modifiedAt: const TimestampConverter().fromJson(json['modifiedAt']),
    );

Map<String, dynamic> _$CommentModelToJson(_CommentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'comment': instance.comment,
      'userId': instance.userId,
      'parentUserId': instance.parentUserId,
      'commentPageType': _$CommentPageTypeEnumMap[instance.commentPageType]!,
      'replies': instance.replies.map((e) => e.toJson()).toList(),
      'articleId': instance.articleId,
      'user': instance.user?.toJson(),
      'parentUser': instance.parentUser?.toJson(),
      'isModify': instance.isModify,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'modifiedAt': const TimestampConverter().toJson(instance.modifiedAt),
    };

const _$CommentPageTypeEnumMap = {
  CommentPageType.datingHistory: 'datingHistory',
};
