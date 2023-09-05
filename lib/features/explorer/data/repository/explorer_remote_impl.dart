import 'package:dartz/dartz.dart';
import 'package:final_mobile/features/profile/domain/entity/profile_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/failure/failure.dart';
import '../../domain/repository/explorer_repository.dart';
import '../data_source/explorer_remote_data_source.dart';

final explorerRemoteRepoProvider = Provider<IExplorerRepository>(
  (ref) => ExplorerRemoteRepositoryImpl(
    explorerRemoteDataSource: ref.read(explorerRemoteDataSourceProvider),
  ),
);

class ExplorerRemoteRepositoryImpl implements IExplorerRepository {
  final ExplorerRemoteDataSource explorerRemoteDataSource;

  ExplorerRemoteRepositoryImpl({required this.explorerRemoteDataSource});

  @override
  Future<Either<Failure, List<ProfileEntity>>> getAllUsers() {
    return explorerRemoteDataSource.getAllUsers();
  }

  @override
  Future<Either<Failure, List<ProfileEntity>>> searchAllUsers(String search) {
    return explorerRemoteDataSource.searchAllUsers(search);
  }
}
