import '../../../domain/entities/entities.dart';

abstract class ISearchTypeDatasource {
  Future<void> changeDefault(UserPreferredSearchType userPreferredSearchType);
  Future<UserPreferredSearchType?> loadDefault();
}
