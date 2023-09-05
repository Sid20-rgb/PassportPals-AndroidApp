// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomeApiModel _$HomeApiModelFromJson(Map<String, dynamic> json) => HomeApiModel(
      blogId: json['_id'] as String?,
      title: json['title'] as String,
      content: json['content'] as String,
      contentImg: (json['contentImg'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      date: json['date'] as String,
      blogCover: json['blogCover'] as String,
      isBookmarked: json['isBookmarked'] as bool?,
      user: json['user'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$HomeApiModelToJson(HomeApiModel instance) =>
    <String, dynamic>{
      '_id': instance.blogId,
      'title': instance.title,
      'content': instance.content,
      'contentImg': instance.contentImg,
      'date': instance.date,
      'blogCover': instance.blogCover,
      'isBookmarked': instance.isBookmarked,
      'user': instance.user,
    };
