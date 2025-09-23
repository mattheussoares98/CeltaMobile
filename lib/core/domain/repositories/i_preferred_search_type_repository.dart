import '../entities/entities.dart';

abstract class IPreferredSearchTypeRepository {
  Future<void> changeDefault(UserPreferredSearchType userPreferredSearchType);
  Future<UserPreferredSearchType?> loadDefault();
}
