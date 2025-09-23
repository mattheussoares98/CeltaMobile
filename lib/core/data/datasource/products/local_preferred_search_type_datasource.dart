import 'package:celta_intelligence/core/domain/entities/product/user_preferred_search_type.dart';
import 'package:hive/hive.dart';

import '../../../constants/database_keys.dart';
import 'products.dart';

class LocalPreferredSearchTypeDatasource
    implements IPreferredSearchTypeDatasource {
  final Box box;
  LocalPreferredSearchTypeDatasource(this.box);

  @override
  Future<void> changeDefault(
    UserPreferredSearchType userPreferredSearchType,
  ) async {
    await box.put(
      DatabaseKeys.userPeferredSearchTypeProducts.name,
      userPreferredSearchType.name,
    );
  }

  @override
  Future<UserPreferredSearchType?> loadDefault() async {
    final value = await box.get(
      DatabaseKeys.userPeferredSearchTypeProducts.name,
    );
    if (value == null) {
      return UserPreferredSearchType.dynamic;
    }

    return UserPreferredSearchType.values.firstWhere(
      (element) => element.name == value,
    );
  }
}
