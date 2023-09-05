import 'package:equatable/equatable.dart';

class ExplorerEntity extends Equatable {
  final String? userId;
  final String userCover;
  final Map<String, dynamic> user;

  const ExplorerEntity({
    this.userId,
    required this.userCover,
    required this.user,
  });

  factory ExplorerEntity.fromJson(Map<String, dynamic> json) {
    return ExplorerEntity(
      userId: json['userId'],
      userCover: json['userCover'],
      user: json['user'],
    );
  }

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "userCover": userCover,
        "user": user,
      };

  @override
  List<Object?> get props => [userId, userCover, user];
}
