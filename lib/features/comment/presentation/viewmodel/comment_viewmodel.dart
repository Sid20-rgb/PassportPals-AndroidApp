import 'package:final_mobile/features/comment/domain/use_case/comment_usecase.dart';
import 'package:final_mobile/features/comment/presentation/state/comment_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final commentViewModelProvider =
    StateNotifierProvider<CommentViewModel, CommentState>(
  (ref) => CommentViewModel(
    ref.read(commentUseCaseProvider),
  ),
);

class CommentViewModel extends StateNotifier<CommentState> {
  final CommentUseCase commentUseCase;

  CommentViewModel(
    this.commentUseCase,
  ) : super(CommentState.initial());

  getAllComments(String id) async {
    state = state.copyWith(isLoading: true);
    final result = await commentUseCase.getAllComments(id);
    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        error: failure.error,
      ),
      (comments) => state = state.copyWith(
        isLoading: false,
        comments: comments,
      ),
    );
  }

  Future<void> addComment(String content, String id) async {
    state = state.copyWith(isLoading: true);

    final result = await commentUseCase.addComment(
      content,
      id,
    );

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        error: failure.error,
      ),
      (data) => state = state.copyWith(
        isLoading: false,
        error: null,
      ),
    );
  }

  Future<void> deleteComment(String id) async {
    state = state.copyWith(isLoading: true);

    final result = await commentUseCase.deleteComment(id);

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        error: failure.error,
      ),
      (data) => state = state.copyWith(
        isLoading: false,
        error: null,
      ),
    );
  }
}
