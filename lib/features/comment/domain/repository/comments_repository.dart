import 'package:dartz/dartz.dart';
import 'package:final_mobile/features/comment/data/repository/comment_remote_repo.dart';
import 'package:final_mobile/features/comment/domain/entity/comment_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/failure/failure.dart';

final commentRepositoryProvider = Provider<ICommentsRepository>(
  (ref) => ref.watch(commentRemoteRepositoryProvider),
);

abstract class ICommentsRepository {
  Future<Either<Failure, List<CommentEntity>>> getAllComments(String id);
  Future<Either<Failure, bool>> addComment(String content, String id);
  Future<Either<Failure, bool>> deleteComment(String id);
}
