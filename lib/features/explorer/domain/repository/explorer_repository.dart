import 'package:dartz/dartz.dart';
import 'package:final_mobile/features/profile/domain/entity/profile_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/common/provider/internet_connectivity.dart';
import '../../../../core/failure/failure.dart';
import '../../data/repository/explorer_remote_impl.dart';

final explorerRepositoryProvider = Provider.autoDispose<IExplorerRepository>(
  (ref) {
    // return ref.watch(batchLocalRepoProvider);
    // // Check for the internet
    final internetStatus = ref.watch(connectivityStatusProvider);

    if (ConnectivityStatus.isConnected == internetStatus) {
      // If internet is available then return remote repo
      return ref.watch(explorerRemoteRepoProvider);
    } else {
      // If internet is not available then return local repo
      return ref.watch(explorerRemoteRepoProvider);
    }
  },
);

abstract class IExplorerRepository {
  Future<Either<Failure, List<ProfileEntity>>> getAllUsers();
  Future<Either<Failure, List<ProfileEntity>>> searchAllUsers(String search);
}
