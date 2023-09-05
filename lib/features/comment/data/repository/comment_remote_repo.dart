import 'package:dartz/dartz.dart';
import 'package:final_mobile/core/failure/failure.dart';
import 'package:final_mobile/features/comment/data/dataSource/all_comments_remote_data_source.dart';
import 'package:final_mobile/features/comment/domain/entity/comment_entity.dart';
import 'package:final_mobile/features/comment/domain/repository/comments_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final commentRemoteRepositoryProvider = Provider<ICommentsRepository>(
  (ref) => CommentRemoteRepositoryImpl(
    commentsRemoteDataSource: ref.read(commentRemoteDataSourceProvider),
  ),
);

class CommentRemoteRepositoryImpl implements ICommentsRepository {
  final CommentsRemoteDataSource commentsRemoteDataSource;

  CommentRemoteRepositoryImpl({
    required this.commentsRemoteDataSource,
  });

  @override
  Future<Either<Failure, List<CommentEntity>>> getAllComments(String id) {
    return commentsRemoteDataSource.getAllComments(id);
  }

  @override
  Future<Either<Failure, bool>> addComment(String content, String id) {
    return commentsRemoteDataSource.addComment(content, id);
  }

  @override
  Future<Either<Failure, bool>> deleteComment(String id) {
    return commentsRemoteDataSource.deleteComment(id);
  }
}
