import 'package:celta_inventario/localization/localization.dart';
import 'package:faker/faker.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final pt = lookupAppLocalizations(const Locale('pt'));
  final en = lookupAppLocalizations(const Locale('en'));
  final faker = Faker();

  test('Saved-order titles use singular and plural in both layouts', () {
    expect(pt.lastSavedOrders(1), 'Último pedido salvo');
    expect(pt.lastSavedOrders(2), 'Últimos pedidos salvos');
    expect(en.lastSavedOrders(1), 'Last saved order');
    expect(en.lastSavedOrders(2), 'Last saved orders');
    expect(pt.lastOrders(1), 'Último pedido');
    expect(pt.lastOrders(2), 'Últimos pedidos');
    expect(en.lastOrders(1), 'Last order');
    expect(en.lastOrders(2), 'Last orders');
  });

  test('Filtered product counts localize the relationship between counts', () {
    expect(pt.filteredProductsCount(2, 8), 'Produtos (2 de 8)');
    expect(en.filteredProductsCount(2, 8), 'Products (2 of 8)');
    expect(pt.productsCount(2), 'Produtos (2)');
    expect(en.productsCount(2), 'Products (2)');
    expect(pt.enterprisesCount(2), 'Empresas (2)');
    expect(en.enterprisesCount(2), 'Enterprises (2)');
  });

  test('Document identifiers are retained without changing their format', () {
    final code = faker.randomGenerator
        .integer(99999999)
        .toString()
        .padLeft(8, '0');
    expect(pt.purchaseOrderDetailsWithCode(code), 'Detalhes pedido ($code)');
    expect(en.purchaseOrderDetailsWithCode(code), 'Order details ($code)');
  });

  test('Competitor headers preserve survey and competitor codes', () {
    final survey = faker.randomGenerator.integer(9999);
    final competitor = faker.randomGenerator.integer(9999);
    expect(
      pt.surveyCompetitorTitle(survey, competitor),
      'Pesquisa $survey - concorrente $competitor',
    );
    expect(
      en.surveyCompetitorTitle(survey, competitor),
      'Survey $survey - competitor $competitor',
    );
  });
}
