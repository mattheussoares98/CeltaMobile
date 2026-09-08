import 'package:celta_inventario/core/providers/ec_request_params/ec_request_params.dart';
import 'package:celta_inventario/features/print_label_layout/domain/repositories/repositories.dart';
import 'package:celta_inventario/features/print_label_layout/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/print_label_layout/presentation/pages/pages.dart';
import 'package:celta_inventario/features/print_label_layout/providers.dart';
import 'package:celta_inventario/routing/routing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

class MockEcPrintLabelLayoutRepository extends Mock
    implements IEcPrintLabelLayoutRepository {}

void main() {
  testWidgets('save action should surface update failures and keep the page', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1200, 1000));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final repository = MockEcPrintLabelLayoutRepository();
    final params = EntityFactory.makeEcRequestParams();
    final layout = EntityFactory.makeBSFPrintLabelLayoutEntity(
      code: 10,
      formWidth: 100,
      formHeight: 50,
      quantityColumns: 1,
      labelWidth: 90,
      labelHeight: 40,
      labelRightMargin: 0,
      labelBottomMargin: 0,
      temperature: 10,
      printSpeed: 2,
      intervalPrintPackage: 1,
      applyFormSizeConfiguration: true,
    );
    final options = EntityFactory.makeBSFPrintLabelFieldEditorOptionsEntity();
    final exception = Exception('Update failed');
    when(
      () => repository.getDetails(params, layout.code),
    ).thenAnswer((_) async => layout);
    when(
      () => repository.getFieldEditorOptions(params, layout),
    ).thenAnswer((_) async => options);
    when(() => repository.update(params, layout)).thenThrow(exception);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          ecRequestParamsProvider().overrideWith((ref) => params),
          ecPrintLabelLayoutRepositoryProvider.overrideWithValue(repository),
        ],
        child: const MaterialApp(
          home: PrintLabelLayoutDetailsPage(labelCode: 10),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('save-print-label-layout')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sim'));
    await tester.pumpAndSettle();

    expect(find.text('Erro'), findsOneWidget);
    expect(find.textContaining('Update failed'), findsOneWidget);
    expect(find.byType(PrintLabelLayoutDetailsPage), findsOneWidget);
    verify(() => repository.update(params, layout)).called(1);
  });

  testWidgets('report action blocks dirty layouts and navigates when clean', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1200, 1000));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final repository = MockEcPrintLabelLayoutRepository();
    final params = EntityFactory.makeEcRequestParams();
    final layout = EntityFactory.makeBSFPrintLabelLayoutEntity(
      code: 10,
      name: 'Saved layout',
      formWidth: 100,
      formHeight: 50,
      quantityColumns: 1,
      labelWidth: 90,
      labelHeight: 40,
      labelRightMargin: 0,
      labelBottomMargin: 0,
      temperature: 10,
      printSpeed: 2,
      intervalPrintPackage: 1,
      applyFormSizeConfiguration: true,
    );
    when(
      () => repository.getDetails(params, layout.code),
    ).thenAnswer((_) async => layout);
    when(() => repository.getFieldEditorOptions(params, layout)).thenAnswer(
      (_) async => EntityFactory.makeBSFPrintLabelFieldEditorOptionsEntity(),
    );
    final router = GoRouter(
      initialLocation: '/details',
      routes: [
        GoRoute(
          path: '/details',
          builder: (_, _) => const PrintLabelLayoutDetailsPage(labelCode: 10),
          routes: [
            GoRoute(
              path: 'problem-report',
              name: Routes.printLabelProblemReport.name,
              builder: (_, _) => const Scaffold(body: Text('Report page')),
            ),
          ],
        ),
      ],
    );
    addTearDown(router.dispose);

    final container = ProviderContainer(
      overrides: [
        ecRequestParamsProvider().overrideWith((ref) => params),
        ecPrintLabelLayoutRepositoryProvider.overrideWithValue(repository),
      ],
    );
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();

    final detailsProvider = printLabelLayoutDetailsControllerProvider(
      layout.code,
    );
    container.read(detailsProvider.notifier).updateName('Changed layout');
    await tester.pump();
    await tester.tap(find.byKey(const Key('report-print-label-problem')));
    await tester.pumpAndSettle();

    expect(find.text('Salve o leiaute'), findsOneWidget);
    expect(find.text('Report page'), findsNothing);

    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    container.read(detailsProvider.notifier).updateName(layout.name);
    await tester.pump();
    await tester.tap(find.byKey(const Key('report-print-label-problem')));
    await tester.pumpAndSettle();

    expect(find.text('Report page'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(minutes: 1));
  });
}
