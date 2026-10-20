import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/localization/localization.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final pt = lookupAppLocalizations(const Locale('pt'));
  final en = lookupAppLocalizations(const Locale('en'));

  test('Modules preserves Portuguese labels and provides English labels', () {
    for (final value in Modules.values) {
      expect(pt.moduleName(value), value.description);
      expect(en.moduleName(value), isNotEmpty);
    }
  });

  test(
    'BsResource preserves Portuguese labels and provides English labels',
    () {
      for (final value in BsResource.values) {
        expect(pt.resourceName(value), value.name);
        expect(en.resourceName(value), isNotEmpty);
      }
    },
  );

  test(
    'PracticedPriceType preserves Portuguese labels and provides English labels',
    () {
      for (final value in PracticedPriceType.values) {
        expect(pt.priceTypeName(value), value.description);
        expect(en.priceTypeName(value), isNotEmpty);
      }
    },
  );

  test(
    'OperationType preserves Portuguese labels and provides English labels',
    () {
      for (final value in OperationType.values) {
        expect(pt.operationName(value), value.name);
        expect(en.operationName(value), isNotEmpty);
      }
    },
  );

  test(
    'SearchProductTypePreference preserves Portuguese labels and provides English labels',
    () {
      for (final value in SearchProductTypePreference.values) {
        expect(pt.searchPreferenceName(value), value.name);
        expect(en.searchPreferenceName(value), isNotEmpty);
      }
    },
  );

  test('UsageType preserves Portuguese labels and provides English labels', () {
    for (final value in UsageType.values) {
      expect(pt.usageName(value), value.description);
      expect(en.usageName(value), isNotEmpty);
    }
  });

  test(
    'CustomerPersonType preserves Portuguese labels and provides English labels',
    () {
      for (final value in CustomerPersonType.values) {
        expect(pt.personTypeName(value), value.completeName);
        expect(en.personTypeName(value), isNotEmpty);
      }
    },
  );

  test(
    'SearchProductCompetingPriceType preserves Portuguese labels and provides English labels',
    () {
      for (final value in SearchProductCompetingPriceType.values) {
        expect(pt.competingPriceFilterName(value), value.name);
        expect(en.competingPriceFilterName(value), isNotEmpty);
      }
    },
  );

  test(
    'CustomerSexType preserves Portuguese labels and provides English labels',
    () {
      for (final value in CustomerSexType.values) {
        expect(pt.sexName(value), value.name);
        expect(en.sexName(value), isNotEmpty);
      }
    },
  );

  test(
    'TransferJustificationType preserves Portuguese labels and provides English labels',
    () {
      for (final value in TransferJustificationType.values) {
        expect(pt.transferJustificationName(value), value.name);
        expect(en.transferJustificationName(value), isNotEmpty);
      }
    },
  );
}
