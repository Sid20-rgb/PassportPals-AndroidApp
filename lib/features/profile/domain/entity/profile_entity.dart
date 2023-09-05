import 'package:equatable/equatable.dart';

class ProfileEntity extends Equatable {
  final String username;
  final String email;
  final List<String> bookmarkedBlogs;
  final String? image;
  final String id;

  const ProfileEntity({
    required this.username,
    required this.email,
    required this.bookmarkedBlogs,
    this.image,
    required this.id,
  });

  factory ProfileEntity.fromJson(Map<String, dynamic> json) => ProfileEntity(
        username: json["username"],
        email: json["email"],
        bookmarkedBlogs:
            List<String>.from(json["bookmarkedBlogs"].map((x) => x)),
        image: json["image"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "email": email,
        "bookmarkedBlogs": List<dynamic>.from(bookmarkedBlogs.map((x) => x)),
        "image": image,
        "id": id,
      };

  @override
  List<Object?> get props => [
        username,
        email,
        bookmarkedBlogs,
        image,
        id,
      ];
}
