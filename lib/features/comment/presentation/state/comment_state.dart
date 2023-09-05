import 'package:final_mobile/features/comment/domain/entity/comment_entity.dart';

class CommentState {
  final bool isLoading;
  final List<CommentEntity> comments;
  final String? error;

  CommentState({
    required this.isLoading,
    required this.comments,
    required this.error,
  });

  factory CommentState.initial() {
    return CommentState(
      isLoading: false,
      comments: [],
      error: null,
    );
  }

  CommentState copyWith({
    bool? isLoading,
    List<CommentEntity>? comments,
    String? error,
  }) {
    return CommentState(
      isLoading: isLoading ?? this.isLoading,
      comments: comments ?? this.comments,
      error: error ?? this.error,
    );
  }
}
