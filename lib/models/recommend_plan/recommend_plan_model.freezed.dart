// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recommend_plan_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RecommendPlanModel {

 String get id;// UUID
@JsonKey(name: 'date_plan_title') String get title;@JsonKey(name: 'why_recommend_dating_plans') String get description;@JsonKey(name: 'date_places') List<PlaceModel> get places;@JsonKey(name: 'baseAddress') AddressModel get baseAddress;@TimestampConverterNotNull() DateTime get date;@TimestampConverterNotNull() DateTime get createdAt;@TimestampConverterNotNull() DateTime get modifiedAt;
/// Create a copy of RecommendPlanModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecommendPlanModelCopyWith<RecommendPlanModel> get copyWith => _$RecommendPlanModelCopyWithImpl<RecommendPlanModel>(this as RecommendPlanModel, _$identity);

  /// Serializes this RecommendPlanModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecommendPlanModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other.places, places)&&(identical(other.baseAddress, baseAddress) || other.baseAddress == baseAddress)&&(identical(other.date, date) || other.date == date)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.modifiedAt, modifiedAt) || other.modifiedAt == modifiedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,const DeepCollectionEquality().hash(places),baseAddress,date,createdAt,modifiedAt);

@override
String toString() {
  return 'RecommendPlanModel(id: $id, title: $title, description: $description, places: $places, baseAddress: $baseAddress, date: $date, createdAt: $createdAt, modifiedAt: $modifiedAt)';
}


}

/// @nodoc
abstract mixin class $RecommendPlanModelCopyWith<$Res>  {
  factory $RecommendPlanModelCopyWith(RecommendPlanModel value, $Res Function(RecommendPlanModel) _then) = _$RecommendPlanModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'date_plan_title') String title,@JsonKey(name: 'why_recommend_dating_plans') String description,@JsonKey(name: 'date_places') List<PlaceModel> places,@JsonKey(name: 'baseAddress') AddressModel baseAddress,@TimestampConverterNotNull() DateTime date,@TimestampConverterNotNull() DateTime createdAt,@TimestampConverterNotNull() DateTime modifiedAt
});


$AddressModelCopyWith<$Res> get baseAddress;

}
/// @nodoc
class _$RecommendPlanModelCopyWithImpl<$Res>
    implements $RecommendPlanModelCopyWith<$Res> {
  _$RecommendPlanModelCopyWithImpl(this._self, this._then);

  final RecommendPlanModel _self;
  final $Res Function(RecommendPlanModel) _then;

/// Create a copy of RecommendPlanModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? description = null,Object? places = null,Object? baseAddress = null,Object? date = null,Object? createdAt = null,Object? modifiedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,places: null == places ? _self.places : places // ignore: cast_nullable_to_non_nullable
as List<PlaceModel>,baseAddress: null == baseAddress ? _self.baseAddress : baseAddress // ignore: cast_nullable_to_non_nullable
as AddressModel,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,modifiedAt: null == modifiedAt ? _self.modifiedAt : modifiedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of RecommendPlanModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AddressModelCopyWith<$Res> get baseAddress {
  
  return $AddressModelCopyWith<$Res>(_self.baseAddress, (value) {
    return _then(_self.copyWith(baseAddress: value));
  });
}
}


/// @nodoc

@JsonSerializable(explicitToJson: true)
class _RecommendPlanModel implements RecommendPlanModel {
  const _RecommendPlanModel({required this.id, @JsonKey(name: 'date_plan_title') required this.title, @JsonKey(name: 'why_recommend_dating_plans') required this.description, @JsonKey(name: 'date_places') required final  List<PlaceModel> places, @JsonKey(name: 'baseAddress') required this.baseAddress, @TimestampConverterNotNull() required this.date, @TimestampConverterNotNull() required this.createdAt, @TimestampConverterNotNull() required this.modifiedAt}): _places = places;
  factory _RecommendPlanModel.fromJson(Map<String, dynamic> json) => _$RecommendPlanModelFromJson(json);

@override final  String id;
// UUID
@override@JsonKey(name: 'date_plan_title') final  String title;
@override@JsonKey(name: 'why_recommend_dating_plans') final  String description;
 final  List<PlaceModel> _places;
@override@JsonKey(name: 'date_places') List<PlaceModel> get places {
  if (_places is EqualUnmodifiableListView) return _places;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_places);
}

@override@JsonKey(name: 'baseAddress') final  AddressModel baseAddress;
@override@TimestampConverterNotNull() final  DateTime date;
@override@TimestampConverterNotNull() final  DateTime createdAt;
@override@TimestampConverterNotNull() final  DateTime modifiedAt;

/// Create a copy of RecommendPlanModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecommendPlanModelCopyWith<_RecommendPlanModel> get copyWith => __$RecommendPlanModelCopyWithImpl<_RecommendPlanModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RecommendPlanModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RecommendPlanModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other._places, _places)&&(identical(other.baseAddress, baseAddress) || other.baseAddress == baseAddress)&&(identical(other.date, date) || other.date == date)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.modifiedAt, modifiedAt) || other.modifiedAt == modifiedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,const DeepCollectionEquality().hash(_places),baseAddress,date,createdAt,modifiedAt);

@override
String toString() {
  return 'RecommendPlanModel(id: $id, title: $title, description: $description, places: $places, baseAddress: $baseAddress, date: $date, createdAt: $createdAt, modifiedAt: $modifiedAt)';
}


}

/// @nodoc
abstract mixin class _$RecommendPlanModelCopyWith<$Res> implements $RecommendPlanModelCopyWith<$Res> {
  factory _$RecommendPlanModelCopyWith(_RecommendPlanModel value, $Res Function(_RecommendPlanModel) _then) = __$RecommendPlanModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'date_plan_title') String title,@JsonKey(name: 'why_recommend_dating_plans') String description,@JsonKey(name: 'date_places') List<PlaceModel> places,@JsonKey(name: 'baseAddress') AddressModel baseAddress,@TimestampConverterNotNull() DateTime date,@TimestampConverterNotNull() DateTime createdAt,@TimestampConverterNotNull() DateTime modifiedAt
});


@override $AddressModelCopyWith<$Res> get baseAddress;

}
/// @nodoc
class __$RecommendPlanModelCopyWithImpl<$Res>
    implements _$RecommendPlanModelCopyWith<$Res> {
  __$RecommendPlanModelCopyWithImpl(this._self, this._then);

  final _RecommendPlanModel _self;
  final $Res Function(_RecommendPlanModel) _then;

/// Create a copy of RecommendPlanModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? description = null,Object? places = null,Object? baseAddress = null,Object? date = null,Object? createdAt = null,Object? modifiedAt = null,}) {
  return _then(_RecommendPlanModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,places: null == places ? _self._places : places // ignore: cast_nullable_to_non_nullable
as List<PlaceModel>,baseAddress: null == baseAddress ? _self.baseAddress : baseAddress // ignore: cast_nullable_to_non_nullable
as AddressModel,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,modifiedAt: null == modifiedAt ? _self.modifiedAt : modifiedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of RecommendPlanModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AddressModelCopyWith<$Res> get baseAddress {
  
  return $AddressModelCopyWith<$Res>(_self.baseAddress, (value) {
    return _then(_self.copyWith(baseAddress: value));
  });
}
}

// dart format on
