import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/common/snackbar/my_snackbar.dart';
import '../../domain/usecase/profile_use_case.dart';
import '../state/profile_state.dart';

final profileViewModelProvider =
    StateNotifierProvider<ProfileViewModel, ProfileState>(
  (ref) => ProfileViewModel(
    ref.read(profileUseCaseProvider),
  ),
);

class ProfileViewModel extends StateNotifier<ProfileState> {
  final ProfileUseCase profileUseCase;

  ProfileViewModel(this.profileUseCase) : super(ProfileState.initial()) {
    getAllProfile();
  }

  void resetState() {
    state = ProfileState.initial();
  }

  getAllProfile() async {
    state = state.copyWith(isLoading: true);
    var data = await profileUseCase.getAllProfile();
    data.fold(
      (l) => state = state.copyWith(isLoading: false, error: l.error),
      (r) => state = state.copyWith(isLoading: false, profiles: r, error: null),
    );
  }

  Future<void> editProfile(
      String username, String email, BuildContext context) async {
    state = state.copyWith(isLoading: true);
    var data = await profileUseCase.editProfile(username, email);
    data.fold(
      (l) {
        state = state.copyWith(isLoading: false, error: l.error);
        showSnackBar(message: l.error, context: context, color: Colors.red);
      },
      (success) {
        state = state.copyWith(isLoading: false, error: null);
        showSnackBar(
          message: 'Profile updated successfully',
          context: context,
        );
      },
    );
  }

  Future<void> uploadImage(File? file) async {
    state = state.copyWith(isLoading: true);
    var data = await profileUseCase.uploadProfilePicture(file!);
    data.fold(
      (l) {
        state = state.copyWith(isLoading: false, error: l.error);
      },
      (imageName) {
        state =
            state.copyWith(isLoading: false, error: null, imageName: imageName);
      },
    );
  }
}
