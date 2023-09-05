import 'package:dartz/dartz.dart';
import 'package:final_mobile/config/router/app_route.dart';
import 'package:final_mobile/config/theme/app_theme.dart';
import 'package:final_mobile/features/auth/domain/entity/user_entity.dart';
import 'package:final_mobile/features/auth/domain/use_case/auth_usecase.dart';
import 'package:final_mobile/features/auth/presentation/viewmodel/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mockito/mockito.dart';

import '../test/unit_test/auth_test.mocks.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  TestWidgetsFlutterBinding.ensureInitialized();

  late AuthUseCase mockAuthUsecase;

  late UserEntity authEntity;

  setUpAll(
    () async {
      mockAuthUsecase = MockAuthUseCase();

      authEntity = const UserEntity(
          username: 'sid', email: 'sid@gmail.com', password: 'sid123456');
    },
  );

  testWidgets('register view ...', (tester) async {
    when(mockAuthUsecase.registerUser(authEntity))
        .thenAnswer((_) async => const Right(true));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authViewModelProvider.overrideWith(
            (ref) => AuthViewModel(mockAuthUsecase),
          ),
        ],
        child: MaterialApp(
          initialRoute: AppRoute.registerRoute,
          routes: AppRoute.getApplicationRoute(),
          debugShowCheckedModeBanner: false,
          theme: AppTheme.getApplicationTheme(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Enter kiran in first textform field
    await tester.enterText(find.byType(TextFormField).at(0), 'sid');
    // Enter kiran123 in second textform field
    await tester.enterText(find.byType(TextFormField).at(1), 'sid@gmail.com');
    // Enter phone no
    await tester.enterText(find.byType(TextFormField).at(2), 'sid123456');

    final registerButtonFinder = find.widgetWithText(ElevatedButton, 'Sign Up');

    await tester.dragUntilVisible(
      registerButtonFinder, // what you want to find
      find.byType(SingleChildScrollView), // widget you want to scroll
      const Offset(196.4, 556.0), // delta to move
    );

    await tester.tap(registerButtonFinder);

    await tester.pump();

    expect(find.widgetWithText(SnackBar, 'Registered successfully'),
        findsOneWidget);
  });
}
