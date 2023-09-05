import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/common/provider/internet_connectivity.dart';
import '../../../../core/failure/failure.dart';

import '../../../home/domain/entity/home_entity.dart';
import '../../data/repository/search_remote_repo_impl.dart';

final searchRepositoryProvider = Provider.autoDispose<ISearchRepository>(
  (ref) {
    // return ref.watch(batchLocalRepoProvider);
    // // Check for the internet
    final internetStatus = ref.watch(connectivityStatusProvider);

    return ref.watch(searchRemoteRepoProvider);

    // if (ConnectivityStatus.isConnected == internetStatus) {
    //   // If internet is available then return remote repo
    //   return ref.watch(searchRemoteRepoProvider);
    // } else {
    //   // If internet is not available then return local repo
    //   return ref.watch(searchLocalRepoProvider);
    // }
  },
);

abstract class ISearchRepository {
  Future<Either<Failure, List<HomeEntity>>> getSearchedBlogs(String searchQuery);
}