import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String? id;
  final String username;
  final String email;
  final String password;

  const UserEntity({
    this.id,
    required this.username,
    required this.email,
    required this.password,
  });

  // factory UserEntity.fromJson(Map<String, dynamic> json) {
  //   return UserEntity(
  //     id: json['id'],
  //     username: json['username'],
  //     email: json['email'],
  //     password: json['password'],
  //   );
  // }

  // Map<String, dynamic> toJson() {
  //   return {
  //     'id': id,
  //     'username': username,
  //     'email': email,
  //     'password': password,
  //   };
  // }

  @override
  List<Object?> get props => [id, username, email, password];
}
