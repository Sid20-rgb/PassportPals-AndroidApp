import '../../domain/entity/home_entity.dart';

class HomeState {
  final bool isLoading;
  final List<HomeEntity> blogs;
  final List<HomeEntity> bookmarkedBlogs;
  final List<HomeEntity> userBlogs;
  final String? imageName;
  final String? error;

  HomeState({
    required this.isLoading,
    required this.blogs,
    required this.bookmarkedBlogs,
    required this.userBlogs,
    this.imageName,
    this.error,
  });

  factory HomeState.initial() => HomeState(
        isLoading: false,
        blogs: [],
        bookmarkedBlogs: [],
        userBlogs: [],
        imageName: null,
      );

  HomeState copyWith({
    bool? isLoading,
    List<HomeEntity>? blogs,
    List<HomeEntity>? bookmarkedBlogs,
    List<HomeEntity>? userBlogs,
    String? imageName,
    String? error,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      blogs: blogs ?? this.blogs,
      bookmarkedBlogs: bookmarkedBlogs ?? this.bookmarkedBlogs,
      userBlogs: userBlogs ?? this.userBlogs,
      imageName: imageName ?? this.imageName,
      error: error ?? this.error,
    );
  }
}
