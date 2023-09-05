// dart run build_runner build --delete-conflicting-outputs
import 'package:dartz/dartz.dart';
import 'package:final_mobile/features/home/domain/entity/home_entity.dart';
import 'package:final_mobile/features/home/domain/use_case/home_use_case.dart';
import 'package:final_mobile/features/home/presentation/viewmodel/home_view_model.dart';
import 'package:final_mobile/features/profile/domain/usecase/profile_use_case.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../test_data/home_entity_test.dart';
import 'home_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<HomeUseCase>(),
  MockSpec<ProfileUseCase>(),
])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late ProviderContainer container;
  late HomeUseCase mockHomeUsecase;
  late ProfileUseCase mockProfileUsecase;
  late List<HomeEntity> homeEntity;

  setUpAll(() async {
    mockHomeUsecase = MockHomeUseCase();
    mockProfileUsecase = MockProfileUseCase();
    homeEntity = await getBlogListTest();

    when(mockHomeUsecase.getAllBlogs())
        .thenAnswer((_) async => const Right([]));
    when(mockHomeUsecase.getBookmarkedBlogs())
        .thenAnswer((_) async => const Right([]));
    when(mockHomeUsecase.getUserBlogs())
        .thenAnswer((_) async => const Right([]));
    when(mockProfileUsecase.getAllProfile())
        .thenAnswer((_) async => const Right([]));

    container = ProviderContainer(
      overrides: [
        homeViewModelProvider.overrideWith(
          (ref) => HomeViewModel(mockHomeUsecase),
        ),
      ],
    );
  });

  test('check home initial state', () {
    final homeState = container.read(homeViewModelProvider);

    expect(homeState.isLoading, true);
    expect(homeState.blogs, isEmpty);
  });

  test('check for the list of homees when calling getAllHomees', () async {
    when(mockHomeUsecase.getAllBlogs())
        .thenAnswer((_) => Future.value(Right(homeEntity)));

    await container.read(homeViewModelProvider.notifier).getAllBlogs();

    final homeState = container.read(homeViewModelProvider);

    expect(homeState.isLoading, false);
    expect(homeState.blogs.length, 2);
  });

  tearDownAll(() {
    container.dispose();
  });
}
