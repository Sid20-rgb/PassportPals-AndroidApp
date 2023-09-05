import 'package:dartz/dartz.dart';
import 'package:final_mobile/features/profile/domain/entity/profile_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/failure/failure.dart';
import '../repository/explorer_repository.dart';

final explorerUsecaseProvider = Provider.autoDispose<ExplorerUseCase>(
  (ref) => ExplorerUseCase(
    explorerRepository: ref.watch(explorerRepositoryProvider),
  ),
);

class ExplorerUseCase {
  final IExplorerRepository explorerRepository;

  ExplorerUseCase({required this.explorerRepository});

  Future<Either<Failure, List<ProfileEntity>>> getAllUsers() async {
    return explorerRepository.getAllUsers();
  }

  Future<Either<Failure, List<ProfileEntity>>> searchAllUsers(
      String search) async {
    return explorerRepository.searchAllUsers(search);
  }
}
