import '../../../domain/entities/entities.dart';

abstract class IPreferredSearchTypeDatasource {
  Future<void> changeDefault(UserPreferredSearchType userPreferredSearchType);
  Future<UserPreferredSearchType?> loadDefault();
}
