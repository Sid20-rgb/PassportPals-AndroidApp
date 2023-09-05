// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_user_blogs_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetUserBlogsDTO _$GetUserBlogsDTOFromJson(Map<String, dynamic> json) =>
    GetUserBlogsDTO(
      data: (json['data'] as List<dynamic>)
          .map((e) => HomeApiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GetUserBlogsDTOToJson(GetUserBlogsDTO instance) =>
    <String, dynamic>{
      'data': instance.data,
    };
