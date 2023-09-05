import 'package:dartz/dartz.dart';
import 'package:final_mobile/config/router/app_route.dart';
import 'package:final_mobile/config/theme/app_theme.dart';
import 'package:final_mobile/features/explorer/domain/use_case/explorer_use_case.dart';
import 'package:final_mobile/features/explorer/presentation/viewmodel/explorer_view_model.dart';
import 'package:final_mobile/features/profile/domain/entity/profile_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../test/unit_test/explorer_test.mocks.dart';
import '../test_data/explorer_entity_test.dart';

void main() {
  late ExplorerUseCase mockExplorerUsecase;
  late List<ProfileEntity> explorerEntity;

  setUpAll(() async {
    mockExplorerUsecase = MockExplorerUseCase();
    explorerEntity = await getAllUsers();
  });

  testWidgets('Explorer Page Details', (tester) async {
    when(mockExplorerUsecase.getAllUsers())
        .thenAnswer((_) async => Right(explorerEntity));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          explorerViewModelProvider
              .overrideWith((ref) => ExplorerViewModel(mockExplorerUsecase)),
        ],
        child: MaterialApp(
          routes: AppRoute.getApplicationRoute(),
          initialRoute: AppRoute.explorerRoute,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.getApplicationTheme(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(GridView), findsWidgets);

    expect(find.byType(ListTile), findsNWidgets(2));
  });
}