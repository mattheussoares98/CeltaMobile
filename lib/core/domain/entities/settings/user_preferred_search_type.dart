import 'package:flutter/material.dart';
import '../entities.dart';

enum SearchProductTypePreference
    implements SelectableItem<SearchProductTypePreference> {
  dynamic('Dinâmico', SearchType.dynamic),
  personalizedCode(
    'Código personalizado',
    SearchType.approximatePersonalizedCode,
  ),
  legacyCode('Código legado', SearchType.approximateLegacyCode);

  @override
  final String name;
  final SearchType searchType;

  const SearchProductTypePreference(this.name, this.searchType);

  @override
  SearchProductTypePreference get value => this;
  @override
  Color? get color => null;
}
