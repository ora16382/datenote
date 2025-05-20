import 'package:freezed_annotation/freezed_annotation.dart';

part 'place_model.freezed.dart';
part 'place_model.g.dart';

@freezed
abstract class PlaceModel with _$PlaceModel {
  const factory PlaceModel({
    required String id,
    required String place_name,
    required String category_group_code,
    required String category_group_name,
    required String category_name,
    required String road_address_name,
    required String address_name,
    required String x,
    required String y,
    required String place_url,
    String? phone,
    String? distance,
    int? index,
  }) = _PlaceModel;

  factory PlaceModel.fromJson(Map<String, dynamic> json) =>
      _$PlaceModelFromJson(json);
}
