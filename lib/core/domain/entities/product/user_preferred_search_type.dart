import 'package:flutter/material.dart';
import '../../../../core/domain/entities/entities.dart';

enum UserPreferredSearchType
    implements SelectableItem<UserPreferredSearchType> {
  dynamic('Dinâmico', SearchType.dynamic),
  byCode('Código personalizado', SearchType.approximatePersonalizedCode),
  byLegacyCode('Código legado', SearchType.approximateLegacyCode);

  @override
  final String name;
  final SearchType searchType;

  const UserPreferredSearchType(this.name, this.searchType);

  @override
  UserPreferredSearchType get value => this;
  @override
  Color? get color => null;
}
