// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_bookmarked_blogs_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetBookmarkedBlogsDTO _$GetBookmarkedBlogsDTOFromJson(
        Map<String, dynamic> json) =>
    GetBookmarkedBlogsDTO(
      data: (json['data'] as List<dynamic>)
          .map((e) => HomeApiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GetBookmarkedBlogsDTOToJson(
        GetBookmarkedBlogsDTO instance) =>
    <String, dynamic>{
      'data': instance.data,
    };
