import 'package:dartz/dartz.dart';
import 'package:final_mobile/config/router/app_route.dart';
import 'package:final_mobile/config/theme/app_theme.dart';
import 'package:final_mobile/features/home/domain/entity/home_entity.dart';
import 'package:final_mobile/features/home/domain/use_case/home_use_case.dart';
import 'package:final_mobile/features/home/presentation/viewmodel/home_view_model.dart';
import 'package:final_mobile/features/profile/domain/entity/profile_entity.dart';
import 'package:final_mobile/features/profile/domain/usecase/profile_use_case.dart';
import 'package:final_mobile/features/profile/presentation/viewmodel/profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mockito/mockito.dart';

import '../test/unit_test/home_test.mocks.dart';
import '../test_data/home_entity_test.dart';
import '../test_data/profile_entity_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  TestWidgetsFlutterBinding.ensureInitialized();

  late HomeUseCase mockHomeUseCase;
  late ProfileUseCase mockProfileUsecase;
  late List<HomeEntity> userBlogs;
  late List<ProfileEntity> profileEntity;
  late List<HomeEntity> bookMarkedBlogs;
  late List<HomeEntity> homeEntity;

  setUpAll(() async {
    mockHomeUseCase = MockHomeUseCase();
    userBlogs = await getUserBlogs();
    mockProfileUsecase = MockProfileUseCase();
    profileEntity = await getAllProfile();
    homeEntity = await getBlogListTest();
    bookMarkedBlogs = await getBookmarkedBlogs();
  });

  testWidgets('profile screen data loads', (tester) async {
    when(mockHomeUseCase.getUserBlogs())
        .thenAnswer((_) async => Right(userBlogs));
    when(mockProfileUsecase.getAllProfile())
        .thenAnswer((_) async => Right(profileEntity));
    when(mockHomeUseCase.getAllBlogs())
        .thenAnswer((_) async => Right(homeEntity));
    when(mockHomeUseCase.getBookmarkedBlogs())
        .thenAnswer((_) async => Right(bookMarkedBlogs));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          homeViewModelProvider
              .overrideWith((ref) => HomeViewModel(mockHomeUseCase)),
          profileViewModelProvider
              .overrideWith((ref) => ProfileViewModel(mockProfileUsecase)),
        ],
        child: MaterialApp(
          routes: AppRoute.getApplicationRoute(),
          initialRoute: AppRoute.profileRoute,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.getApplicationTheme(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(ListView), findsWidgets);
  });
}