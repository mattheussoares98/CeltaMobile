import 'dart:ui';

import '../entities.dart';

enum SearchProductCompetingPriceType
    implements SelectableItem<SearchProductCompetingPriceType> {
  all(0, 'Todos'),
  informedPrices(1, 'Já informados'),
  notInformedPrices(2, 'Não informados');

  @override
  final String name;

  @override
  SearchProductCompetingPriceType get value => this;

  @override
  Color? get color => null;

  final int code;

  const SearchProductCompetingPriceType(this.code, this.name);
}
