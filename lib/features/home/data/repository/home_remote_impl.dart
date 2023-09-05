import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/failure/failure.dart';
import '../../domain/entity/home_entity.dart';
import '../../domain/repository/home_repository.dart';
import '../data_source/home_remote_data_sources.dart';

final homeRemoteRepoProvider = Provider<IHomeRepository>(
  (ref) => HomeRemoteRepositoryImpl(
    homeRemoteDataSource: ref.read(homeRemoteDataSourceProvider),
  ),
);

class HomeRemoteRepositoryImpl implements IHomeRepository {
  final HomeRemoteDataSource homeRemoteDataSource;

  HomeRemoteRepositoryImpl({required this.homeRemoteDataSource});

  @override
  Future<Either<Failure, bool>> addBlog(HomeEntity blog) {
    return homeRemoteDataSource.addBlog(blog);
  }

  @override
  Future<Either<Failure, List<HomeEntity>>> getAllBlogs() {
    return homeRemoteDataSource.getAllBlogs();
  }

  @override
  Future<Either<Failure, List<HomeEntity>>> getBookmarkedBlogs() {
    return homeRemoteDataSource.getBookmarkedBlogs();
  }

  @override
  Future<Either<Failure, bool>> bookmarkBlog(String blogId) {
    return homeRemoteDataSource.bookmarkBlog(blogId);
  }

  @override
  Future<Either<Failure, bool>> unbookmarkBlog(String blogId) {
    return homeRemoteDataSource.unbookmarkBlog(blogId);
  }

  @override
  Future<Either<Failure, String>> uploadBlogCover(File file) {
    return homeRemoteDataSource.uploadBlogCover(file);
  }

  @override
  Future<Either<Failure, List<HomeEntity>>> getUserBlogs() {
    return homeRemoteDataSource.getUserBlogs();
  }

  @override
  Future<Either<Failure, bool>> updateBlog(HomeEntity blog, String blogId) {
    return homeRemoteDataSource.updateBlog(blog, blogId);
  }

  @override
  Future<Either<Failure, bool>> deleteBlog(String blogId) {
    return homeRemoteDataSource.deleteBlog(blogId);
  }
}
