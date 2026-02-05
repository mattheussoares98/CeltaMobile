import 'package:flutter/material.dart';
import '../entities.dart';

enum SearchProductTypePreference
    implements SelectableItem<SearchProductTypePreference> {
  dynamic('Dinâmico', SearchType.dynamic),
  personalizedCode('Cód personalizado', SearchType.approximatePersonalizedCode),
  legacyCode('Cód legado', SearchType.approximateLegacyCode),
  ean('EAN', SearchType.ean);

  @override
  final String name;
  final SearchType searchType;

  const SearchProductTypePreference(this.name, this.searchType);

  @override
  SearchProductTypePreference get value => this;
  @override
  Color? get color => null;
}
