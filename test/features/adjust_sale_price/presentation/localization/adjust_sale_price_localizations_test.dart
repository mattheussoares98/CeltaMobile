import 'package:celta_inventario/features/adjust_sale_price/domain/entities/entities.dart';
import 'package:celta_inventario/features/adjust_sale_price/presentation/localization/localization.dart';
import 'package:celta_inventario/localization/localization.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final pt = lookupAppLocalizations(const Locale('pt'));
  final en = lookupAppLocalizations(const Locale('en'));

  test('Portuguese enum labels retain their existing meaning', () {
    for (final type in PriceType.values) {
      expect(pt.adjustmentPriceTypeName(type), type.name);
    }
    for (final type in SaleType.values) {
      expect(pt.saleTypeName(type), type.name);
    }
    for (final type in ReplicationTypes.values) {
      expect(pt.replicationTypeName(type), type.name);
    }
  });

  test('English price and sales types have translated labels', () {
    expect(en.adjustmentPriceTypeName(PriceType.sale), 'Regular');
    expect(en.adjustmentPriceTypeName(PriceType.offer), 'Offer');
    expect(en.saleTypeName(SaleType.retail), 'Retail');
    expect(en.saleTypeName(SaleType.whole), 'Wholesale');
    expect(en.saleTypeName(SaleType.ecommerce), 'E-commerce');
  });

  test('English replication labels cover every option', () {
    expect(en.replicationTypeName(ReplicationTypes.classess), 'Class');
    expect(en.replicationTypeName(ReplicationTypes.grid), 'Variant grid');
    expect(
      en.replicationTypeName(ReplicationTypes.operationalGrouping),
      'Operational group',
    );
    expect(en.replicationTypeName(ReplicationTypes.packings), 'Packaging');
  });

  test('Current-price messages use each language word order', () {
    expect(
      en.missingCurrentPrice(PriceType.sale, SaleType.retail),
      'No current regular price for retail',
    );
    expect(
      pt.missingCurrentPrice(PriceType.sale, SaleType.retail),
      'Sem preço venda varejo praticado',
    );
  });

  test('Suggested-price messages include the selected channel and type', () {
    expect(
      en.missingSuggestedPrice(PriceType.offer, SaleType.ecommerce),
      'No suggested offer price for e-commerce',
    );
    expect(
      pt.missingSuggestedPrice(PriceType.offer, SaleType.ecommerce),
      'Sem preço oferta e-commerce sugerido',
    );
  });

  test('Missing selections use a complete message without null fragments', () {
    for (final l10n in [pt, en]) {
      expect(
        l10n.missingCurrentPrice(null, SaleType.retail),
        l10n.noCurrentPrice,
      );
      expect(
        l10n.missingCurrentPrice(PriceType.sale, null),
        l10n.noCurrentPrice,
      );
      expect(l10n.missingSuggestedPrice(null, null), l10n.noSuggestedPrice);
    }
  });
}
