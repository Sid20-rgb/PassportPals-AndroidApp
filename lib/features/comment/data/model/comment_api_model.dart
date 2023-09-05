import 'package:equatable/equatable.dart';
import 'package:final_mobile/features/comment/domain/entity/comment_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:json_annotation/json_annotation.dart';

part 'comment_api_model.g.dart';

final commentApiModelProvider = Provider<CommentApiModel>(
  (ref) => CommentApiModel.empty(),
);

@JsonSerializable()
class CommentApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String id;

  @JsonKey(name: 'content')
  final String content;

  @JsonKey(name: 'user')
  final UserApiModels user;

  @JsonKey(name: 'createdAt')
  final String createdAt;

  @JsonKey(name: '__v')
  final int v;

  @JsonKey(name: 'isUserLoggedIn')
  final bool isUserLoggedIn;

  const CommentApiModel({
    required this.id,
    required this.content,
    required this.user,
    required this.createdAt,
    required this.v,
    required this.isUserLoggedIn,
  });

  factory CommentApiModel.fromJson(Map<String, dynamic> json) =>
      _$CommentApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$CommentApiModelToJson(this);

  factory CommentApiModel.empty() => CommentApiModel(
        id: '',
        content: '',
        user: UserApiModels.empty(),
        createdAt: '',
        v: 0,
        isUserLoggedIn: false,
      );

  CommentEntity toEntity() {
    return CommentEntity(
      id: id,
      content: content,
      user: user.toEntity(),
      createdAt: createdAt,
      v: v,
      isUserLoggedIn: isUserLoggedIn,
    );
  }

  static CommentApiModel fromEntity(CommentEntity entity) {
    return CommentApiModel(
      id: entity.id,
      content: entity.content,
      user: UserApiModels.fromEntity(entity.user),
      createdAt: entity.createdAt,
      v: entity.v,
      isUserLoggedIn: entity.isUserLoggedIn,
    );
  }

  List<CommentEntity> toEntityList(List<CommentApiModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  List<Object?> get props => [
        id,
        content,
        user,
        createdAt,
        v,
        isUserLoggedIn,
      ];
}

@JsonSerializable()
class UserApiModels extends Equatable {
  @JsonKey(name: 'id')
  final String id;

  final String username;
  final String email;
  final int iat;
  final int exp;

  const UserApiModels({
    required this.id,
    required this.username,
    required this.email,
    required this.iat,
    required this.exp,
  });

  factory UserApiModels.fromJson(Map<String, dynamic> json) =>
      _$UserApiModelsFromJson(json);

  Map<String, dynamic> toJson() => _$UserApiModelsToJson(this);

  factory UserApiModels.empty() => const UserApiModels(
        id: '',
        username: '',
        email: '',
        iat: 0,
        exp: 0,
      );

  UserEnt toEntity() {
    return UserEnt(
      id: id,
      username: username,
      email: email,
      iat: iat,
      exp: exp,
    );
  }

  static UserApiModels fromEntity(UserEnt entity) {
    return UserApiModels(
      id: entity.id,
      username: entity.username,
      email: entity.email,
      iat: entity.iat,
      exp: entity.exp,
    );
  }

  List<UserEnt> toEntityList(List<UserApiModels> models) {
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  List<Object?> get props => [
        id,
        username,
        email,
        iat,
        exp,
      ];
}
