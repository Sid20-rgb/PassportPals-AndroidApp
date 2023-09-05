import 'package:equatable/equatable.dart';
import 'package:final_mobile/features/profile/domain/entity/profile_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:json_annotation/json_annotation.dart';

part 'profile_api_model.g.dart';

final profileApiModelProvider = Provider<ProfileApiModel>(
  (ref) => ProfileApiModel.empty(),
);

@JsonSerializable()
class ProfileApiModel extends Equatable {
  @JsonKey(name: 'username')
  final String username;

  @JsonKey(name: 'email')
  final String email;

  @JsonKey(name: 'bookmarkedBlogs')
  final List<String> bookmarkedBlogs;

  @JsonKey(name: 'image')
  final String? image;

  @JsonKey(name: 'id')
  final String id;

  const ProfileApiModel({
    required this.username,
    required this.email,
    required this.bookmarkedBlogs,
    this.image,
    required this.id,
  });

  ProfileApiModel.empty()
      : username = '',
        email = '',
        bookmarkedBlogs = [],
        image = '',
        id = '';

  ProfileEntity toEntity() => ProfileEntity(
        username: username,
        email: email,
        bookmarkedBlogs: bookmarkedBlogs,
        image: image,
        id: id,
      );

  ProfileApiModel fromEntity(ProfileEntity entity) => ProfileApiModel(
        username: username,
        email: email,
        bookmarkedBlogs: bookmarkedBlogs,
        image: image,
        id: id,
      );

  List<ProfileEntity> toEntityList(List<ProfileApiModel> models) =>
      models.map((model) => model.toEntity()).toList();

  @override
  List<Object?> get props => [
        username,
        email,
        bookmarkedBlogs,
        image,
        id,
      ];

  factory ProfileApiModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileApiModelToJson(this);
}
