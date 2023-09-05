// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'explorer_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExplorerApiModel _$ExplorerApiModelFromJson(Map<String, dynamic> json) =>
    ExplorerApiModel(
      userId: json['_id'] as String?,
      userCover: json['userCover'] as String,
      user: json['user'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$ExplorerApiModelToJson(ExplorerApiModel instance) =>
    <String, dynamic>{
      '_id': instance.userId,
      'userCover': instance.userCover,
      'user': instance.user,
    };
