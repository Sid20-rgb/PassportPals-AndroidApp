import 'package:dartz/dartz.dart';
import 'package:final_mobile/features/explorer/domain/use_case/explorer_use_case.dart';
import 'package:final_mobile/features/explorer/presentation/viewmodel/explorer_view_model.dart';
import 'package:final_mobile/features/profile/domain/entity/profile_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../test_data/explorer_entity_test.dart';
import 'explorer_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<ExplorerUseCase>(),
])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late ProviderContainer container;
  late ExplorerUseCase mockExplorerUsecase;
  late List<ProfileEntity> explorerEntity;

  setUpAll(() async {
    mockExplorerUsecase = MockExplorerUseCase();
    explorerEntity = await getAllUsers();

    when(mockExplorerUsecase.getAllUsers())
        .thenAnswer((_) async => const Right([]));

    container = ProviderContainer(
      overrides: [
        explorerViewModelProvider.overrideWith(
          (ref) => ExplorerViewModel(mockExplorerUsecase),
        ),
      ],
    );
  });

  test('check explorer initial state', () async {
    await container.read(explorerViewModelProvider.notifier).getAllUsers();

    final explorerState = container.read(explorerViewModelProvider);

    expect(explorerState.isLoading, false);
    expect(explorerState.users, isEmpty);
  });

  test('check for the list of users when calling getAllUsers', () async {
    when(mockExplorerUsecase.getAllUsers())
        .thenAnswer((_) => Future.value(Right(explorerEntity)));

    await container.read(explorerViewModelProvider.notifier).getAllUsers();

    final explorerState = container.read(explorerViewModelProvider);

    expect(explorerState.isLoading, false);
    expect(explorerState.users.length, 2);
  });
}
