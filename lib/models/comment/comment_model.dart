import 'package:datenote/constant/converter/timestamp_converter.dart';
import 'package:datenote/constant/enum/comment_page_type.dart';
import 'package:datenote/models/user/user_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'comment_model.freezed.dart';
part 'comment_model.g.dart';

@freezed
abstract class CommentModel with _$CommentModel {
  @JsonSerializable(explicitToJson: true)
  const factory CommentModel({
    required String id,
    required String comment,
    required String userId,
    String? parentUserId,
    required CommentPageType commentPageType,
    @Default([]) List<CommentModel> replies,
    required String articleId, // 댓글이 달린 게시글 ID
    UserModel? user, // 댓글 유저
    UserModel? parentUser, // 부모 댓글 유저
    @Default(false) bool isModify,
    @TimestampConverter() required DateTime createdAt,
    @TimestampConverter() required DateTime modifiedAt,
  }) = _CommentModel;

  factory CommentModel.fromJson(Map<String, dynamic> json) =>
      _$CommentModelFromJson(json);
}