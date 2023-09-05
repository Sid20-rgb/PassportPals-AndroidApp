import 'package:dartz/dartz.dart';
import 'package:final_mobile/config/router/app_route.dart';
import 'package:final_mobile/config/theme/app_theme.dart';
import 'package:final_mobile/features/auth/domain/use_case/auth_usecase.dart';
import 'package:final_mobile/features/auth/presentation/viewmodel/auth_view_model.dart';
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

import '../build/unit_test_assets/test_data/profile_entity_test.dart';
import '../test/unit_test/auth_test.mocks.dart';
import '../test/unit_test/home_test.mocks.dart';
import '../test_data/home_entity_test.dart';

// testWidgets('login view ...', (tester) async {

// });

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  TestWidgetsFlutterBinding.ensureInitialized();
  late AuthUseCase mockAuthUseCase;
  late HomeUseCase mockHomeUsecase;
  late ProfileUseCase mockProfileUsecase;
  late List<HomeEntity> homeEntity;
  late List<ProfileEntity> profileEntity;
  late List<HomeEntity> bookMarkedBlogs;
  late List<HomeEntity> userBlogs;
  late bool isLogin;

  setUpAll(() async {
    //Because these mocks are already created in the register_view_test.dart file
    mockAuthUseCase = MockAuthUseCase();
    mockHomeUsecase = MockHomeUseCase();
    mockProfileUsecase = MockProfileUseCase();
    profileEntity = await getAllProfile();
    homeEntity = await getBlogListTest();
    bookMarkedBlogs = await getBookmarkedBlogs();
    userBlogs = await getUserBlogs();
    isLogin = true;
  });

  testWidgets('login test with username and password and open dashboard',
      (WidgetTester tester) async {
    when(mockAuthUseCase.loginUser('sid', 'sid123'))
        .thenAnswer((_) async => Right(isLogin));
    when(mockHomeUsecase.getAllBlogs())
        .thenAnswer((_) async => Right(homeEntity));
    when(mockHomeUsecase.getBookmarkedBlogs())
        .thenAnswer((_) async => Right(bookMarkedBlogs));
    when(mockHomeUsecase.getUserBlogs())
        .thenAnswer((_) async => Right(userBlogs));
    when(mockProfileUsecase.getAllProfile())
        .thenAnswer((_) async => Right(profileEntity));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authViewModelProvider
              .overrideWith((ref) => AuthViewModel(mockAuthUseCase)),
          homeViewModelProvider
              .overrideWith((ref) => HomeViewModel(mockHomeUsecase)),
          profileViewModelProvider
              .overrideWith((ref) => ProfileViewModel(mockProfileUsecase)),
        ],
        child: MaterialApp(
          initialRoute: AppRoute.loginRoute,
          routes: AppRoute.getApplicationRoute(),
          debugShowCheckedModeBanner: false,
          theme: AppTheme.getApplicationTheme(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).at(0), 'sid');

    await tester.enterText(find.byType(TextFormField).at(1), 'sid123');

    final loginbuttonFinder = find.widgetWithText(ElevatedButton, 'Log In');

    await tester.dragUntilVisible(
      loginbuttonFinder,
      find.byType(SingleChildScrollView),
      const Offset(196.4, 571.0),
    );

    await tester.tap(loginbuttonFinder);
    await tester.pumpAndSettle();

    expect(find.text('Blogs'), findsOneWidget);
  });
}
