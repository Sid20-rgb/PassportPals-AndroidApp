import 'package:final_mobile/features/profile/domain/entity/profile_entity.dart';

class ProfileState {
  final bool isLoading;
  final String? error;
  final String? imageName;
  final List<ProfileEntity> profiles;

  ProfileState({
    required this.isLoading,
    this.error,
    this.imageName,
    required this.profiles,
  });

  factory ProfileState.initial() => ProfileState(
        isLoading: false,
        imageName: null,
        error: null,
        profiles: [],
      );

  ProfileState copyWith({
    bool? isLoading,
    String? error,
    String? imageName,
    List<ProfileEntity>? profiles,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      imageName: imageName ?? this.imageName,
      profiles: profiles ?? this.profiles,
    );
  }

  @override
  String toString() {
    return 'ProfileState{isLoading: $isLoading, error: $error, imageName: $imageName, profiles: $profiles}';
  }
}
