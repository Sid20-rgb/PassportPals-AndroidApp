import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/common/provider/internet_connectivity.dart';
import '../../../../core/failure/failure.dart';
import '../../data/repository/home_local_impl.dart';
import '../../data/repository/home_remote_impl.dart';
import '../entity/home_entity.dart';

final homeRepositoryProvider = Provider.autoDispose<IHomeRepository>(
  (ref) {
    // return ref.watch(batchLocalRepoProvider);
    // // Check for the internet
    final internetStatus = ref.watch(connectivityStatusProvider);

    if (ConnectivityStatus.isConnected == internetStatus) {
      // If internet is available then return remote repo
      return ref.watch(homeRemoteRepoProvider);
    } else {
      // If internet is not available then return local repo
      return ref.watch(homeLocalRepoProvider);
    }
  },
);

abstract class IHomeRepository {
  Future<Either<Failure, List<HomeEntity>>> getAllBlogs();
  Future<Either<Failure, bool>> addBlog(HomeEntity blog);
  Future<Either<Failure, String>> uploadBlogCover(File file);
  Future<Either<Failure, List<HomeEntity>>> getBookmarkedBlogs();
  Future<Either<Failure, bool>> bookmarkBlog(String blogId);
  Future<Either<Failure, bool>> unbookmarkBlog(String blogId);
  Future<Either<Failure, List<HomeEntity>>> getUserBlogs();
  Future<Either<Failure, bool>> deleteBlog(String blogId);
  Future<Either<Failure, bool>> updateBlog(HomeEntity blog, String blogId);

}
