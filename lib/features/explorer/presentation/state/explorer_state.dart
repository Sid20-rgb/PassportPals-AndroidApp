import 'package:final_mobile/features/profile/domain/entity/profile_entity.dart';

class ExplorerState {
  final bool isLoading;
  final List<ProfileEntity> users;
  final List<ProfileEntity> search;
  final String? error;

  ExplorerState({
    required this.isLoading,
    required this.users,
    required this.search,
    this.error,
  });

  factory ExplorerState.initial() => ExplorerState(
        isLoading: false,
        users: [],
        search: [],
      );

  ExplorerState copyWith({
    bool? isLoading,
    List<ProfileEntity>? users,
    List<ProfileEntity>? search,
    String? error,
  }) {
    return ExplorerState(
      isLoading: isLoading ?? this.isLoading,
      users: users ?? this.users,
      search: search ?? this.search,
      error: error ?? this.error,
    );
  }
}
