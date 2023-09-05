import 'package:dartz/dartz.dart';
import 'package:final_mobile/features/comment/domain/repository/comments_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/failure/failure.dart';
import '../entity/comment_entity.dart';

final commentUseCaseProvider = Provider<CommentUseCase>(
  (ref) => CommentUseCase(
    commentRepository: ref.watch(commentRepositoryProvider),
  ),
);

class CommentUseCase {
  final ICommentsRepository commentRepository;

  CommentUseCase({
    required this.commentRepository,
  });

  Future<Either<Failure, List<CommentEntity>>> getAllComments(String id) {
    return commentRepository.getAllComments(id);
  }

  Future<Either<Failure, bool>> addComment(String content, String id) {
    return commentRepository.addComment(content, id);
  }

  Future<Either<Failure, bool>> deleteComment(String id) {
    return commentRepository.deleteComment(id);
  }
}
