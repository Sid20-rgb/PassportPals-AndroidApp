import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:final_mobile/features/profile/domain/entity/profile_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/failure/failure.dart';
import '../entity/password_entity.dart';
import '../repository/profile_repository.dart';

final profileUseCaseProvider = Provider<ProfileUseCase>(
  (ref) => ProfileUseCase(
    profileRepository: ref.watch(profileRepositoryProvider),
  ),
);

class ProfileUseCase {
  final IProfileRepository profileRepository;

  ProfileUseCase({
    required this.profileRepository,
  });

  Future<Either<Failure, String>> uploadProfilePicture(File file) async {
    return profileRepository.uploadProfilePicture(file);
  }

  Future<Either<Failure, List<ProfileEntity>>> getAllProfile() async {
    return profileRepository.getAllProfile();
  }

  Future<Either<Failure, bool>> updateUserProfile(PasswordEntity password) {
    return profileRepository.updateUserProfile(password);
  }

  Future<Either<Failure, bool>> editProfile(
      String username, String email) async {
    return await profileRepository.editProfile(username, email);
  }
}
