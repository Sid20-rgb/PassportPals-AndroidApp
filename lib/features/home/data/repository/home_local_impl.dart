import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/failure/failure.dart';
import '../../domain/entity/home_entity.dart';
import '../../domain/repository/home_repository.dart';
import '../data_source/home_local_data_source.dart';

final homeLocalRepoProvider = Provider<IHomeRepository>((ref) {
  return HomeLocalRepositoryImpl(
    homeLocalDataSource: ref.read(homeLocalDataSourceProvider),
  );
});

class HomeLocalRepositoryImpl implements IHomeRepository {
  final HomeLocalDataSource homeLocalDataSource;

  HomeLocalRepositoryImpl({required this.homeLocalDataSource});
  @override
  Future<Either<Failure, bool>> addBlog(HomeEntity blog) {
    return homeLocalDataSource.addBlog(blog);
  }

  @override
  Future<Either<Failure, String>> uploadBlogCover(File file) async {
    return const Right("");
  }

  @override
  Future<Either<Failure, List<HomeEntity>>> getAllBlogs() {
    return homeLocalDataSource.getAllBlogs();
  }

  @override
  Future<Either<Failure, List<HomeEntity>>> getBookmarkedBlogs() {
    return homeLocalDataSource.getBookmarkedBlogs();
  }

  @override
  Future<Either<Failure, bool>> bookmarkBlog(String blogId) {
    // TODO: implement bookmarkBook
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> unbookmarkBlog(String blogId) {
    // TODO: implement unbookmarkBook
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<HomeEntity>>> getUserBlogs() {
    return homeLocalDataSource.getUserBlogs();
  }

  @override
  Future<Either<Failure, bool>> deleteBlog(String blogId) {
    // TODO: implement deleteBook
    throw UnimplementedError();
  }
  
  @override
  Future<Either<Failure, bool>> updateBlog(HomeEntity blog, String blogId) {
    // TODO: implement updateBook
    throw UnimplementedError();
  }
}
