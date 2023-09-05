import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/failure/failure.dart';
import '../entity/home_entity.dart';
import '../repository/home_repository.dart';

final homeUsecaseProvider = Provider.autoDispose<HomeUseCase>(
  (ref) => HomeUseCase(
    homeRepository: ref.watch(homeRepositoryProvider),
  ),
);

class HomeUseCase {
  final IHomeRepository homeRepository;

  HomeUseCase({required this.homeRepository});

  Future<Either<Failure, List<HomeEntity>>> getAllBlogs() async {
    return homeRepository.getAllBlogs();
  }

  Future<Either<Failure, bool>> addBlog(HomeEntity blog) async {
    return homeRepository.addBlog(blog);
  }

  Future<Either<Failure, List<HomeEntity>>> getBookmarkedBlogs() async {
    return homeRepository.getBookmarkedBlogs();
  }

  Future<Either<Failure, bool>> bookmarkBlog(String blogId) async {
    return homeRepository.bookmarkBlog(blogId);
  }

  Future<Either<Failure, bool>> unbookmarkBlog(String blogId) async {
    return homeRepository.unbookmarkBlog(blogId);
  }

  Future<Either<Failure, List<HomeEntity>>> getUserBlogs() {
    return homeRepository.getUserBlogs();
  }

  Future<Either<Failure, bool>> updateBlog(HomeEntity blog, String blogId) {
    return homeRepository.updateBlog(blog, blogId);
  }

  Future<Either<Failure, bool>> deleteBlog(String blogId) {
    return homeRepository.deleteBlog(blogId);
  }

  Future<Either<Failure, String>> uploadBlogCover(File file) {
    return homeRepository.uploadBlogCover(file);
  }
}
