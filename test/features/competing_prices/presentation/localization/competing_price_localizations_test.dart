import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/competing_prices/presentation/localization/localization.dart';
import 'package:celta_inventario/localization/localization.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final pt = lookupAppLocalizations(const Locale('pt'));
  final en = lookupAppLocalizations(const Locale('en'));

  test('Associated product queries use complete English messages', () {
    expect(
      en.competingProductsQuery(
        onlyAssociated: true,
        searchType: SearchProductCompetingPriceType.all,
      ),
      'Load all associated products',
    );
    expect(
      en.competingProductsQuery(
        onlyAssociated: true,
        searchType: SearchProductCompetingPriceType.informedPrices,
      ),
      'Load all associated products with prices',
    );
    expect(
      en.competingProductsQuery(
        onlyAssociated: true,
        searchType: SearchProductCompetingPriceType.notInformedPrices,
      ),
      'Load all associated products without prices',
    );
  });

  test('Associated product queries preserve the Portuguese meaning', () {
    expect(
      pt.competingProductsQuery(
        onlyAssociated: true,
        searchType: SearchProductCompetingPriceType.all,
      ),
      'Consultar todos',
    );
    expect(
      pt.competingProductsQuery(
        onlyAssociated: true,
        searchType: SearchProductCompetingPriceType.informedPrices,
      ),
      'Consultar todos já informados',
    );
    expect(
      pt.competingProductsQuery(
        onlyAssociated: true,
        searchType: SearchProductCompetingPriceType.notInformedPrices,
      ),
      'Consultar todos não informados',
    );
  });

  test('Unassociated queries ignore the associated-price filter', () {
    for (final filter in SearchProductCompetingPriceType.values) {
      expect(
        en.competingProductsQuery(onlyAssociated: false, searchType: filter),
        'Load all unassociated products',
      );
      expect(
        pt.competingProductsQuery(onlyAssociated: false, searchType: filter),
        'Consultar todos não associados',
      );
    }
  });

  test(
    'Retail prices and regular price types have distinct English meanings',
    () {
      expect(en.retailPrice, 'Retail');
      expect(en.regularPrice, 'Regular');
      expect(en.offerPriceLabel(en.retailPrice), en.retailOfferPrice);
      expect(en.offerPriceLabel(en.ecommercePrice), en.ecommerceOfferPrice);
    },
  );

  test('Survey save feedback distinguishes creation from update', () {
    expect(en.priceSurveySaved('create'), 'Price survey created successfully');
    expect(en.priceSurveySaved('update'), 'Price survey updated successfully');
    expect(pt.priceSurveySaved('create'), 'Pesquisa inserida com sucesso');
    expect(pt.priceSurveySaved('update'), 'Pesquisa alterada com sucesso');
  });

  test('Competitor save feedback distinguishes creation from update', () {
    expect(en.competitorSaved('create'), 'Competitor created successfully');
    expect(en.competitorSaved('update'), 'Competitor updated successfully');
    expect(pt.competitorSaved('create'), 'Concorrente inserido com sucesso');
    expect(pt.competitorSaved('update'), 'Concorrente alterado com sucesso');
  });
}
