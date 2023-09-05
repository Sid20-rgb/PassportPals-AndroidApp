import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entity/home_entity.dart';
import '../../domain/use_case/home_use_case.dart';
import '../state/home_state.dart';

final homeViewModelProvider = StateNotifierProvider<HomeViewModel, HomeState>(
  (ref) => HomeViewModel(ref.read(homeUsecaseProvider)),
);

class HomeViewModel extends StateNotifier<HomeState> {
  final HomeUseCase homeUseCase;

  HomeViewModel(this.homeUseCase) : super(HomeState.initial()) {
    getAllBlogs();
    getBookmarkedBlogs();
    getUserBlogs();
  }

  Future<void> uploadBlogCover(File? file) async {
    state = state.copyWith(isLoading: true);
    var data = await homeUseCase.uploadBlogCover(file!);
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

  addBlog(HomeEntity blog) async {
    state.copyWith(isLoading: true);
    var data = await homeUseCase.addBlog(blog);

    data.fold(
      (l) => state = state.copyWith(isLoading: false, error: l.error),
      (r) => state = state.copyWith(isLoading: false, error: null),
    );
  }

  getAllBlogs() async {
    state = state.copyWith(isLoading: true);
    var data = await homeUseCase.getAllBlogs();
    // state = state.copyWith(blogs: []);

    data.fold(
      (l) => state = state.copyWith(isLoading: false, error: l.error),
      (r) => state = state.copyWith(isLoading: false, blogs: r, error: null),
    );
  }

  getBookmarkedBlogs() async {
    state = state.copyWith(isLoading: true);
    var data = await homeUseCase.getBookmarkedBlogs();
    state = state.copyWith(bookmarkedBlogs: []);

    data.fold(
      (l) => state = state.copyWith(isLoading: false, error: l.error),
      (r) => state =
          state.copyWith(isLoading: false, bookmarkedBlogs: r, error: null),
    );
  }

  bookmarkBlog(String blogId) async {
    state = state.copyWith(isLoading: true);
    var data = await homeUseCase.bookmarkBlog(blogId);
    state = state.copyWith(isLoading: false);

    data.fold(
      (l) => state = state.copyWith(isLoading: false, error: l.error),
      (r) => state = state.copyWith(isLoading: false, error: null),
    );
  }

  unbookmarkBlog(String blogId) async {
    state = state.copyWith(isLoading: true);
    var data = await homeUseCase.unbookmarkBlog(blogId);
    state = state.copyWith(isLoading: false);

    data.fold(
      (l) => state = state.copyWith(isLoading: false, error: l.error),
      (r) => state = state.copyWith(isLoading: false, error: null),
    );
  }

  getUserBlogs() async {
    state = state.copyWith(isLoading: true);
    var data = await homeUseCase.getUserBlogs();
    state = state.copyWith(userBlogs: []);

    data.fold(
      (l) => state = state.copyWith(isLoading: false, error: l.error),
      (r) =>
          state = state.copyWith(isLoading: false, userBlogs: r, error: null),
    );
  }

  updateBlog(HomeEntity blog, String blogId) async {
    state = state.copyWith(isLoading: true);
    var data = await homeUseCase.updateBlog(blog, blogId);
    state = state.copyWith(isLoading: false);

    data.fold(
      (l) => state = state.copyWith(isLoading: false, error: l.error),
      (r) => state = state.copyWith(isLoading: false, error: null),
    );
  }

  deleteBlog(String blogId) async {
    state = state.copyWith(isLoading: true);
    var data = await homeUseCase.deleteBlog(blogId);
    state = state.copyWith(isLoading: false);

    data.fold(
      (l) => state = state.copyWith(isLoading: false, error: l.error),
      (r) => state = state.copyWith(isLoading: false, error: null),
    );
  }
}
