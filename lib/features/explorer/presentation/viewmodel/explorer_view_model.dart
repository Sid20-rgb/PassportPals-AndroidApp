import 'package:final_mobile/features/explorer/presentation/state/explorer_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/use_case/explorer_use_case.dart';

final explorerViewModelProvider =
    StateNotifierProvider<ExplorerViewModel, ExplorerState>(
  (ref) => ExplorerViewModel(ref.read(explorerUsecaseProvider)),
);

class ExplorerViewModel extends StateNotifier<ExplorerState> {
  final ExplorerUseCase explorerUseCase;

  ExplorerViewModel(this.explorerUseCase) : super(ExplorerState.initial()) {
    getAllUsers();
  }

  getAllUsers() async {
    state = state.copyWith(isLoading: true);
    var data = await explorerUseCase.getAllUsers();
    // state = state.copyWith(users: []);

    data.fold(
      (l) => state = state.copyWith(isLoading: false, error: l.error),
      (r) => state = state.copyWith(isLoading: false, users: r, error: null),
    );
  }

  searchAllUsers(String search) async {
    state = state.copyWith(isLoading: true);
    var data = await explorerUseCase.searchAllUsers(search);

    data.fold(
      (l) => state = state.copyWith(isLoading: false, error: l.error),
      (r) => state = state.copyWith(isLoading: false, search: r, error: null),
    );
  }
}
