import 'package:datenote/constant/converter/timestamp_converter.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'address_model.freezed.dart';
part 'address_model.g.dart';

@freezed
abstract class AddressModel with _$AddressModel {
  const factory AddressModel({
    required String id, // UUID
    required String address, // 기본 주소 (지번/도로명)
    required String detailAddress, // 상세 주소 (건물명, 호수 등)
    required String addressName, // 사용자가 설정한 주소 이름 (예: 집, 회사)
    required double latitude,
    required double longitude,
    @TimestampConverterNotNull() required DateTime createdAt,
    @TimestampConverterNotNull() required DateTime orderDate, // 사용자가 선택한 데이트 날짜
  }) = _AddressModel;

  factory AddressModel.fromJson(Map<String, dynamic> json) => _$AddressModelFromJson(json);
}
