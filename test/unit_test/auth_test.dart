// dart run build_runner build --delete-conflicting-outputs
import 'package:dartz/dartz.dart';
import 'package:final_mobile/core/failure/failure.dart';
import 'package:final_mobile/features/auth/domain/entity/user_entity.dart';
import 'package:final_mobile/features/auth/domain/use_case/auth_usecase.dart';
import 'package:final_mobile/features/auth/presentation/viewmodel/auth_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'auth_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<AuthUseCase>(),
  MockSpec<BuildContext>(),
])
void main() {
  late AuthUseCase mockAuthUseCase;
  late ProviderContainer container;
  late BuildContext context;
  late UserEntity userEntity;

  setUp(() {
    mockAuthUseCase = MockAuthUseCase();
    context = MockBuildContext();
    userEntity = const UserEntity(
      username: 'kirans',
      email: 'kirans@gmail.com',
      password: 'kirans123',
    );
    
    container = ProviderContainer(overrides: [
      authViewModelProvider.overrideWith(
        (ref) => AuthViewModel(mockAuthUseCase),
      ),
    ]);
  });

  test('check for the initial state', () async {
    final authState = container.read(authViewModelProvider);
    expect(authState.isLoading, false);
  });

  test('login test with valid username and password', () async {
    when(mockAuthUseCase.loginUser('sid', 'sid123'))
        .thenAnswer((_) async => Future.value(const Right(true)));

    await container
        .read(authViewModelProvider.notifier)
        .loginUser(context, 'sid', 'sid123');

    final authState = container.read(authViewModelProvider);

    expect(authState.error, isNull);
  });

  //   test('login test with valid username and password', () async {
  //   when(mockAuthUseCase.registerUser(userEntity))
  //       .thenAnswer((_) => Future.value(const Right(true)));

  //   await container
  //       .read(authViewModelProvider.notifier)
  //       .registerUser(const UserEntity(
  //         username: 'kirans',
  //         password: 'kirans123',
  //       ));

  //   final authState = container.read(authViewModelProvider);
  //   expect(authState.error, null);
  // });

  test('login test with invalid username and password', () async {
    when(mockAuthUseCase.loginUser('fosd', 'djds123'))
        .thenAnswer((_) async => Future.value(Left(Failure(error: 'Invalid'))));

    await container
        .read(authViewModelProvider.notifier)
        .loginUser(context, 'fo', 'djds123');

    final authState = container.read(authViewModelProvider);

    expect(authState.error, 'Invalid');
  });

  test('register test with valid username and password', () async {
    when(mockAuthUseCase.registerUser(userEntity))
        .thenAnswer((_) => Future.value(const Right(true)));

    await container
        .read(authViewModelProvider.notifier)
        .registerUser(const UserEntity(
          username: 'kirans',
          email: 'kirans@gmail.com',
          password: 'kirans123',
        ));

    final authState = container.read(authViewModelProvider);
    expect(authState.error, null);
  });

  test('register test with invalid user information', () async {
    when(mockAuthUseCase.registerUser(userEntity))
        .thenAnswer((_) => Future.value(Left(Failure(error: "Invalid"))));

    await container
        .read(authViewModelProvider.notifier)
        .registerUser(userEntity);

    final authState = container.read(authViewModelProvider);
    expect(authState.error, isNotNull);
  });

  tearDownAll(() {
    container.dispose();
  });
}
