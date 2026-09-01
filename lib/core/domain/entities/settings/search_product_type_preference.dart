import 'package:celta_inventario/core/domain/entities/entities.dart';

enum SearchProductTypePreference {
  dynamic('Dinâmico', SearchType.dynamic),
  personalizedCode('Cód personalizado', SearchType.approximatePersonalizedCode),
  legacyCode('Cód legado', SearchType.approximateLegacyCode),
  ean('EAN', SearchType.ean);

  final String name;
  final SearchType searchType;

  const SearchProductTypePreference(this.name, this.searchType);
}
