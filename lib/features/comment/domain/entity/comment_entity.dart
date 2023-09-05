import 'package:equatable/equatable.dart';

class CommentEntity extends Equatable {
  final String id;
  final String content;
  final UserEnt user;
  final String createdAt;
  final int v;
  final bool isUserLoggedIn;

  const CommentEntity({
    required this.id,
    required this.content,
    required this.user,
    required this.createdAt,
    required this.v,
    required this.isUserLoggedIn,
  });

  factory CommentEntity.fromJson(Map<String, dynamic> json) => CommentEntity(
        id: json["_id"],
        content: json["content"],
        user: UserEnt.fromJson(json["user"]),
        createdAt: json["createdAt"],
        v: json["__v"],
        isUserLoggedIn: json["isUserLoggedIn"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "content": content,
        "user": user.toJson(),
        "createdAt": createdAt,
        "__v": v,
        "isUserLoggedIn": isUserLoggedIn,
      };

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

class UserEnt extends Equatable {
  final String id;
  final String username;
  final String email;
  final int iat;
  final int exp;

  const UserEnt({
    required this.id,
    required this.username,
    required this.email,
    required this.iat,
    required this.exp,
  });

  factory UserEnt.fromJson(Map<String, dynamic> json) => UserEnt(
        id: json["id"],
        username: json["username"],
        email: json["email"],
        iat: json["iat"],
        exp: json["exp"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "email": email,
        "iat": iat,
        "exp": exp,
      };

  @override
  List<Object?> get props => [
        id,
        username,
        email,
        iat,
        exp,
      ];
}
