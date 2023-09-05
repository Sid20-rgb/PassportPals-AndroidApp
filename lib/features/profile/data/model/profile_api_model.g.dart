// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileApiModel _$ProfileApiModelFromJson(Map<String, dynamic> json) =>
    ProfileApiModel(
      username: json['username'] as String,
      email: json['email'] as String,
      bookmarkedBlogs: (json['bookmarkedBlogs'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      image: json['image'] as String?,
      id: json['id'] as String,
    );

Map<String, dynamic> _$ProfileApiModelToJson(ProfileApiModel instance) =>
    <String, dynamic>{
      'username': instance.username,
      'email': instance.email,
      'bookmarkedBlogs': instance.bookmarkedBlogs,
      'image': instance.image,
      'id': instance.id,
    };
