// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_searched_blogs_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetSearchedBlogsDTO _$GetSearchedBlogsDTOFromJson(Map<String, dynamic> json) =>
    GetSearchedBlogsDTO(
      data: (json['data'] as List<dynamic>)
          .map((e) => HomeApiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GetSearchedBlogsDTOToJson(
        GetSearchedBlogsDTO instance) =>
    <String, dynamic>{
      'data': instance.data,
    };
