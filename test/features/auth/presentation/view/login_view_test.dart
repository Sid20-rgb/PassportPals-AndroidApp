import 'package:dartz/dartz.dart';
import 'package:final_mobile/config/router/app_route.dart';
import 'package:final_mobile/features/auth/domain/use_case/auth_usecase.dart';
import 'package:final_mobile/features/auth/presentation/viewmodel/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../../../unit_test/auth_test.mocks.dart';


// testWidgets('login view ...', (tester) async {

// });

void main() {
  late AuthUseCase mockAuthUseCase;
  // we are doing these for dashboard
  late bool isLogin;

  setUpAll(() async {
    //Because these mocks are already created in the register_view_test.dart file
    mockAuthUseCase = MockAuthUseCase();
    isLogin = true;
  });

  testWidgets('login test with username and password and open dashboard',
      (WidgetTester tester) async {
    when(mockAuthUseCase.loginUser('sid', 'sid123'))
        .thenAnswer((_) async => Right(isLogin));


    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authViewModelProvider
              .overrideWith((ref) => AuthViewModel(mockAuthUseCase)),
        ],
        child: MaterialApp(
          initialRoute: AppRoute.loginRoute,
          routes: AppRoute.getApplicationRoute(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).at(0), 'sid');

    await tester.enterText(find.byType(TextFormField).at(1), 'sid123');

    await tester.tap(find.widgetWithText(ElevatedButton, 'Log In'));

    await tester.pumpAndSettle();

    expect(find.text('Siddhartha'), findsOneWidget);
  });
}
