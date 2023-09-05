import 'package:dartz/dartz.dart';
import 'package:final_mobile/features/home/domain/use_case/home_use_case.dart';
import 'package:final_mobile/features/profile/domain/entity/profile_entity.dart';
import 'package:final_mobile/features/profile/domain/usecase/profile_use_case.dart';
import 'package:final_mobile/features/profile/presentation/viewmodel/profile_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../test_data/profile_entity_test.dart';
import 'home_test.mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ProviderContainer container;
  late HomeUseCase mockHomeUsecase;
  late ProfileUseCase mockProfileUsecase;
  late List<ProfileEntity> profileEntity;

  setUpAll(() async {
    mockHomeUsecase = MockHomeUseCase();
    mockProfileUsecase = MockProfileUseCase();

    profileEntity = await getAllProfile();

    when(mockHomeUsecase.getUserBlogs())
        .thenAnswer((_) async => const Right([]));
    when(mockProfileUsecase.getAllProfile())
        .thenAnswer((_) async => const Right([]));

    container = ProviderContainer(
      overrides: [
        profileViewModelProvider.overrideWith(
          (ref) => ProfileViewModel(mockProfileUsecase),
        ),
      ],
    );
  });

  test('check profile initial state', () {
    final profileState = container.read(profileViewModelProvider);

    expect(profileState.isLoading, true);
    expect(profileState.profiles, isEmpty);
  });

  test('check for the list of profiles when calling getAllProfiles', () async {
    when(mockProfileUsecase.getAllProfile())
        .thenAnswer((_) => Future.value(Right(profileEntity)));

    await container.read(profileViewModelProvider.notifier).getAllProfile();

    final profileState = container.read(profileViewModelProvider);

    expect(profileState.isLoading, false);
    expect(profileState.profiles.length, 1);
  });
}
