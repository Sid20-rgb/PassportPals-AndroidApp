// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_all_comments_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetAllCommentsDTO _$GetAllCommentsDTOFromJson(Map<String, dynamic> json) =>
    GetAllCommentsDTO(
      comments: (json['comments'] as List<dynamic>)
          .map((e) => CommentApiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GetAllCommentsDTOToJson(GetAllCommentsDTO instance) =>
    <String, dynamic>{
      'comments': instance.comments,
    };
