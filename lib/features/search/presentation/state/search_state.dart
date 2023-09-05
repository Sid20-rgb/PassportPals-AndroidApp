

import '../../../home/domain/entity/home_entity.dart';

class SearchState {
  final bool isLoading;
  final List<HomeEntity> searchedBlogs;
  final String? error;

  SearchState({
    required this.isLoading,
    required this.searchedBlogs,
    this.error,
  });

  factory SearchState.initial() {
    return SearchState(isLoading: false, searchedBlogs: []);
  }

  SearchState copyWith({
    bool? isLoading,
    List<HomeEntity>? searchedBlogs,
    String? error,
  }) {
    return SearchState(
      isLoading: isLoading ?? this.isLoading,
      searchedBlogs: searchedBlogs ?? this.searchedBlogs,
      error: error ?? this.error,
    );
  }
}