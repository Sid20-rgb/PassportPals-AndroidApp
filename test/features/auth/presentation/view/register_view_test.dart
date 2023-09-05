// import 'package:dartz/dartz.dart';
// import 'package:final_mobile/config/router/app_route.dart';
// import 'package:final_mobile/features/auth/domain/entity/user_entity.dart';
// import 'package:final_mobile/features/auth/domain/use_case/auth_usecase.dart';
// import 'package:final_mobile/features/auth/presentation/viewmodel/auth_view_model.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_test/flutter_test.dart';

// // import integration_test\register_test.dart

// import 'package:integration_test/integration_test.dart';
// import 'package:mockito/annotations.dart';
// import 'package:mockito/mockito.dart';
// import 'package:multi_select_flutter/multi_select_flutter.dart';

// import '../../../../unit_test/auth_test.mocks.dart';


// void main() {
//   IntegrationTestWidgetsFlutterBinding.ensureInitialized();
//   TestWidgetsFlutterBinding.ensureInitialized();

//   late AuthUseCase mockAuthUsecase;
 

//   late UserEntity userEntity;

//   setUpAll(
//     () async {
//       mockAuthUsecase = MockAuthUseCase();
//       userEntity = UserEntity(
//         id: null,
//         username: 'sid',
//         email: 'sid@gmail.com',
//         password: 'sid123',
//       );
//     },
//   );

//   testWidgets('register view ...', (tester) async {

//     when(mockAuthUsecase.registerUser(userEntity))
//         .thenAnswer((_) async => const Right(true));

//     await tester.pumpWidget(
//       ProviderScope(
//         overrides: [
//           authViewModelProvider.overrideWith(
//             (ref) => AuthViewModel(mockAuthUsecase),
//           ),
//         ],
//         child: MaterialApp(
//           initialRoute: AppRoute.registerRoute,
//           routes: AppRoute.getApplicationRoute(),
//         ),
//       ),
//     );

//     await tester.pumpAndSettle();
//     // Enter kiran in first textform field
//     await tester.enterText(find.byType(TextFormField).at(0), 'sid');
//     await tester.enterText(find.byType(TextFormField).at(1), 'sid@gmail.com');
//     await tester.enterText(find.byType(TextFormField).at(2), 'sid123');

//     //=========================== Find the dropdownformfield===========================

  
//     //expect(dropdownFinder, findsOneWidget);

//     //=========================== Find the register button===========================
//     final registerButtonFinder =
//         find.widgetWithText(ElevatedButton, 'Sign In');

//     await tester.tap(registerButtonFinder);

//     await tester.pumpAndSettle();

//     expect(find.text('Welcome'), findsOneWidget);
//   });
// }