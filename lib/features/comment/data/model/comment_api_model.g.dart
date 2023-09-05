// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommentApiModel _$CommentApiModelFromJson(Map<String, dynamic> json) =>
    CommentApiModel(
      id: json['_id'] as String,
      content: json['content'] as String,
      user: UserApiModels.fromJson(json['user'] as Map<String, dynamic>),
      createdAt: json['createdAt'] as String,
      v: json['__v'] as int,
      isUserLoggedIn: json['isUserLoggedIn'] as bool,
    );

Map<String, dynamic> _$CommentApiModelToJson(CommentApiModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'content': instance.content,
      'user': instance.user,
      'createdAt': instance.createdAt,
      '__v': instance.v,
      'isUserLoggedIn': instance.isUserLoggedIn,
    };

UserApiModels _$UserApiModelsFromJson(Map<String, dynamic> json) =>
    UserApiModels(
      id: json['id'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      iat: json['iat'] as int,
      exp: json['exp'] as int,
    );

Map<String, dynamic> _$UserApiModelsToJson(UserApiModels instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'email': instance.email,
      'iat': instance.iat,
      'exp': instance.exp,
    };
