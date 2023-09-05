// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_all_user_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetAllUsersDTO _$GetAllUsersDTOFromJson(Map<String, dynamic> json) =>
    GetAllUsersDTO(
      data: (json['data'] as List<dynamic>)
          .map((e) => ProfileApiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GetAllUsersDTOToJson(GetAllUsersDTO instance) =>
    <String, dynamic>{
      'data': instance.data,
    };
