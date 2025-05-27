import 'package:datenote/constant/converter/timestamp_converter.dart';
import 'package:datenote/constant/enum/assets_type.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'asset_model.freezed.dart';
part 'asset_model.g.dart';

@freezed
abstract class AssetModel with _$AssetModel {
  const factory AssetModel({
    required String id,
    String? url,
    /// 기본적으로 enum은 json_serializable에서 자동 직렬화/역직렬화가 된다.
    /// enum을 커스텀 문자열로 매핑하고 싶다면 → @JsonKey(fromJson: ..., toJson: ...)으로 명시해줘야 한다.
    required AssetType type,
    @TimestampConverterNotNull() required DateTime createdAt,
    String? thumbnailUrl,
  }) = _AssetModel;

  factory AssetModel.fromJson(Map<String, dynamic> json) =>
      _$AssetModelFromJson(json);
}