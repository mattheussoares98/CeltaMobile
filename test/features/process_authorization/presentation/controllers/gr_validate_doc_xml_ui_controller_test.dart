import 'package:celta_inventario/features/process_authorization/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/process_authorization/presentation/models/models.dart';
import 'package:faker/faker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late ProviderContainer container;
  late int processCode;

  setUp(() {
    processCode = faker.randomGenerator.integer(1000);
    container = ProviderContainer(retry: (retryCount, error) => null);
  });

  tearDown(() {
    container.dispose();
  });

  group('GRValidateDocXmlUiController', () {
    test('build should return an empty state initially', () {
      final state = container.read(
        gRValidateDocXmlUiControllerProvider(processCode),
      );

      expect(state, GRValidateDocXmlUiModel.empty());
    });

    test('toggleProductWithJudgment should select and unselect a product', () {
      final productCode = faker.randomGenerator.integer(1000);
      final notifier = container.read(
        gRValidateDocXmlUiControllerProvider(processCode).notifier,
      );

      notifier.toggleProductWithJudgment(productCode);

      expect(
        container
            .read(gRValidateDocXmlUiControllerProvider(processCode))
            .selectedProductsWithJudgmentIds,
        {productCode},
      );

      notifier.toggleProductWithJudgment(productCode);

      expect(
        container
            .read(gRValidateDocXmlUiControllerProvider(processCode))
            .selectedProductsWithJudgmentIds,
        isEmpty,
      );
    });

    test(
      'toggleProductWithoutJudgment should select and unselect a product',
      () {
        final productCode = faker.randomGenerator.integer(1000);
        final notifier = container.read(
          gRValidateDocXmlUiControllerProvider(processCode).notifier,
        );

        notifier.toggleProductWithoutJudgment(productCode);

        expect(
          container
              .read(gRValidateDocXmlUiControllerProvider(processCode))
              .selectedProductsWithoutJudgmentIds,
          {productCode},
        );

        notifier.toggleProductWithoutJudgment(productCode);

        expect(
          container
              .read(gRValidateDocXmlUiControllerProvider(processCode))
              .selectedProductsWithoutJudgmentIds,
          isEmpty,
        );
      },
    );

    test('toggle methods should keep both selected sets separated', () {
      const productWithJudgmentCode = 10;
      const productWithoutJudgmentCode = 20;
      final notifier = container.read(
        gRValidateDocXmlUiControllerProvider(processCode).notifier,
      );

      notifier.toggleProductWithJudgment(productWithJudgmentCode);
      notifier.toggleProductWithoutJudgment(productWithoutJudgmentCode);

      final state = container.read(
        gRValidateDocXmlUiControllerProvider(processCode),
      );

      expect(state.selectedProductsWithJudgmentIds, {productWithJudgmentCode});
      expect(state.selectedProductsWithoutJudgmentIds, {
        productWithoutJudgmentCode,
      });
    });

    for (final areJudgedItems in [false, true]) {
      test(
        'clearSelectedProducts should clear only the ${areJudgedItems ? 'judged' : 'unjudged'} selection',
        () {
          final notifier = container.read(
            gRValidateDocXmlUiControllerProvider(processCode).notifier,
          );
          notifier.toggleProductWithJudgment(10);
          notifier.toggleProductWithoutJudgment(20);

          notifier.clearSelectedProducts(areJudgedItems: areJudgedItems);

          final state = container.read(
            gRValidateDocXmlUiControllerProvider(processCode),
          );
          expect(
            state.selectedProductsWithJudgmentIds,
            areJudgedItems ? isEmpty : {10},
          );
          expect(
            state.selectedProductsWithoutJudgmentIds,
            areJudgedItems ? {20} : isEmpty,
          );
        },
      );
    }

    test('updatePageIndex should update selectedPageIndex', () {
      final pageIndex = faker.randomGenerator.integer(2);
      final notifier = container.read(
        gRValidateDocXmlUiControllerProvider(processCode).notifier,
      );

      notifier.updatePageIndex(pageIndex);

      final state = container.read(
        gRValidateDocXmlUiControllerProvider(processCode),
      );

      expect(state.selectedPageIndex, pageIndex);
    });
  });
}
