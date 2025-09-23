import 'package:celta_intelligence/core/domain/entities/product/user_preferred_search_type.dart';

import '../../data/datasource/datasource.dart';
import 'repositores.dart';

class LocalPreferredSearchTypeRepository
    implements IPreferredSearchTypeRepository {
  final IPreferredSearchTypeDatasource preferredSearchTypeDatasource;

  LocalPreferredSearchTypeRepository(this.preferredSearchTypeDatasource);

  @override
  Future<void> changeDefault(
    UserPreferredSearchType userPreferredSearchType,
  ) async {
    await preferredSearchTypeDatasource.changeDefault(userPreferredSearchType);
  }

  @override
  Future<UserPreferredSearchType?> loadDefault() async {
    return await preferredSearchTypeDatasource.loadDefault();
  }
}
