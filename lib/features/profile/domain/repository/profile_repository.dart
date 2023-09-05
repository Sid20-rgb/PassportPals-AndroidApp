import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:final_mobile/features/profile/domain/entity/profile_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/failure/failure.dart';
import '../../data/repository/profile_remote_repo_impl.dart';
import '../entity/password_entity.dart';

final profileRepositoryProvider = Provider<IProfileRepository>(
  (ref) => ref.watch(profileRemoteRepoProvider),
);

abstract class IProfileRepository {
  Future<Either<Failure, String>> uploadProfilePicture(File file);

  Future<Either<Failure, List<ProfileEntity>>> getAllProfile();

  Future<Either<Failure, bool>> updateUserProfile(PasswordEntity password);
  Future<Either<Failure, bool>> editProfile(String username, String email);
}
