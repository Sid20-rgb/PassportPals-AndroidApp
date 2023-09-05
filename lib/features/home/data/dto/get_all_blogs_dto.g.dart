// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_all_blogs_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetAllBlogDTO _$GetAllBlogDTOFromJson(Map<String, dynamic> json) =>
    GetAllBlogDTO(
      data: (json['data'] as List<dynamic>)
          .map((e) => HomeApiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GetAllBlogDTOToJson(GetAllBlogDTO instance) =>
    <String, dynamic>{
      'data': instance.data,
    };
