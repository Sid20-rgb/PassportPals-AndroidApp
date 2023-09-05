import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import 'package:uuid/uuid.dart';

import '../../../../config/constants/hive_tabel_constant.dart';
import '../../domain/entity/user_entity.dart';

part 'auth_hive_model.g.dart';

final authHiveModelProvider = Provider(
  (ref) => AuthHiveModel.empty(),
);

@HiveType(typeId: HiveTableConstant.userTableId)
class AuthHiveModel {
  @HiveField(0)
  final String userId;

  @HiveField(1)
  final String username;

  @HiveField(2)
  final String email;

  @HiveField(3)
  final String password;

  // Constructor
  AuthHiveModel({
    String? userId,
    required this.username,
    required this.email,
    required this.password,
  }) : userId = userId ?? const Uuid().v4();

  // empty constructor
  AuthHiveModel.empty()
      : this(
          userId: '',
          username: '',
          email: '',
          password: '',
        );

  // Convert Hive Object to Entity
  UserEntity toEntity() => UserEntity(
        id: userId,
        username: username,
        email: email,
        password: password,
      );

  // Convert Entity to Hive Object
  AuthHiveModel toHiveModel(UserEntity entity) => AuthHiveModel(
        userId: const Uuid().v4(),
        username: entity.username,
        email: entity.email,
        password: entity.password,
      );

  // Convert Entity List to Hive List
  List<AuthHiveModel> toHiveModelList(List<UserEntity> entities) =>
      entities.map((entity) => toHiveModel(entity)).toList();

  @override
  String toString() {
    return 'userId: $userId,  username: $username, email: $email password: $password';
  }
}
