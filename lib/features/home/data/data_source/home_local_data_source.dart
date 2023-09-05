import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/failure/failure.dart';
import '../../../../core/network/local/hive_service.dart';
import '../../domain/entity/home_entity.dart';
import '../model/home_hive_model.dart';

// Dependency Injection using Riverpod
final homeLocalDataSourceProvider = Provider<HomeLocalDataSource>((ref) {
  return HomeLocalDataSource(
      hiveService: ref.read(hiveServiceProvider),
      homeHiveModel: ref.read(homeHiveModelProvider));
});

class HomeLocalDataSource {
  final HiveService hiveService;
  final HomeHiveModel homeHiveModel;

  HomeLocalDataSource({
    required this.hiveService,
    required this.homeHiveModel,
  });

  // Add Batch
  Future<Either<Failure, bool>> addBlog(HomeEntity blog) async {
    try {
      // Convert Entity to Hive Object
      final hiveBlog = homeHiveModel.toHiveModel(blog);
      // Add to Hive
      await hiveService.addBlog(hiveBlog);
      return const Right(true);
    } catch (e) {
      return Left(Failure(error: e.toString()));
    }
  }

  

  Future<Either<Failure, List<HomeEntity>>> getAllBlogs() async {
    try {
      // Get all batches from Hive
      final blogs = await hiveService.getAllBlogs();
      // Convert Hive Object to Entity
      final homeEntities = homeHiveModel.toEntityList(blogs);
      return Right(homeEntities);
    } catch (e) {
      return Left(Failure(error: e.toString()));
    }
  }

  Future<Either<Failure, List<HomeEntity>>> getBookmarkedBlogs() async {
    try {
      // Get all batches from Hive
      final blogs = await hiveService.getBookmarkedBlogs();
      // Convert Hive Object to Entity
      final homeEntities = homeHiveModel.toEntityList(blogs);
      return Right(homeEntities);
    } catch (e) {
      return Left(Failure(error: e.toString()));
    }
  }

  Future<Either<Failure, List<HomeEntity>>> getUserBlogs() async {
    try {
      // Get all batches from Hive
      final blogs = await hiveService.getUserBlogs();
      // Convert Hive Object to Entity
      final homeEntities = homeHiveModel.toEntityList(blogs);
      return Right(homeEntities);
    } catch (e) {
      return Left(Failure(error: e.toString()));
    }
  }


  

}
