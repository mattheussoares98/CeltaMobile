import 'package:flutter/material.dart';
import '../entities.dart';

enum UserPreferredSearchType
    implements SelectableItem<UserPreferredSearchType> {
  dynamic('Dinâmico', SearchType.dynamic),
  personalizedCode(
    'Código personalizado',
    SearchType.approximatePersonalizedCode,
  ),
  legacyCode('Código legado', SearchType.approximateLegacyCode);

  @override
  final String name;
  final SearchType searchType;

  const UserPreferredSearchType(this.name, this.searchType);

  @override
  UserPreferredSearchType get value => this;
  @override
  Color? get color => null;
}
