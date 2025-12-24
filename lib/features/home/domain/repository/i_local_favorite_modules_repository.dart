import '../../../../core/domain/entities/entities.dart';

abstract class ILocalFavoriteModulesRepository {
  Future<void> toggle(Modules module);
  Future<List<Modules>> load();
}
