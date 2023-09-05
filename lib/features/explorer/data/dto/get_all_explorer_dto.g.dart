// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_all_explorer_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetAllUserDTO _$GetAllUserDTOFromJson(Map<String, dynamic> json) =>
    GetAllUserDTO(
      user: (json['user'] as List<dynamic>)
          .map((e) => ProfileApiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GetAllUserDTOToJson(GetAllUserDTO instance) =>
    <String, dynamic>{
      'user': instance.user,
    };
