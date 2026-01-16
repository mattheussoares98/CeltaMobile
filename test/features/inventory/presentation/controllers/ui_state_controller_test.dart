import 'package:celta_intelligence/features/inventory/presentation/controllers/controllers.dart';
import 'package:celta_intelligence/features/inventory/presentation/models/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:faker/faker.dart';

void main() {
  late ProviderContainer container;
  late Faker faker;
  late int codigoInternoInvCont;

  setUp(() {
    container = ProviderContainer();
    faker = Faker();
    codigoInternoInvCont = faker.randomGenerator.integer(100);
    addTearDown(container.dispose);
  });

  group('Build', () {
    test('build should have an initial state of null', () {
      // ARRANGE / ACT
      final state = container.read(
        uiStateControllerProvider(codigoInternoInvCont),
      );

      // ASSERT
      expect(state, const UiStateModel());
    });
  });

  group('Update index', () {
    test('Should toggle the index correctly', () {
      // ARRANGE
      final newIndex = faker.randomGenerator.integer(100);
      final notifier = container.read(
        uiStateControllerProvider(codigoInternoInvCont).notifier,
      );

      expect(
        container
            .read(uiStateControllerProvider(codigoInternoInvCont))
            .selectedProductIndex,
        isNull,
      );

      // ACT
      notifier.updateProductIndex(newIndex);
      // ASSERT
      expect(
        container
            .read(uiStateControllerProvider(codigoInternoInvCont))
            .selectedProductIndex,
        newIndex,
      );

      // ACT
      notifier.updateProductIndex(newIndex);
      // ASSERT
      expect(
        container
            .read(uiStateControllerProvider(codigoInternoInvCont))
            .selectedProductIndex,
        isNull,
      );
    });
  });

  group('Update insert individually', () {
    test('Should toggle correctly', () {
      // ARRANGE
      final notifier = container.read(
        uiStateControllerProvider(codigoInternoInvCont).notifier,
      );

      expect(
        container
            .read(uiStateControllerProvider(codigoInternoInvCont))
            .insertIndividually,
        isFalse,
      );

      // ACT
      notifier.updateInsertIndividually();
      // ASSERT
      expect(
        container
            .read(uiStateControllerProvider(codigoInternoInvCont))
            .insertIndividually,
        isTrue,
      );

      // ACT
      notifier.updateInsertIndividually();
      // ASSERT
      expect(
        container
            .read(uiStateControllerProvider(codigoInternoInvCont))
            .insertIndividually,
        isFalse,
      );
    });
  });
}
