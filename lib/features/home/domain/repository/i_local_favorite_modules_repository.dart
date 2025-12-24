import '../../../../core/domain/entities/entities.dart';

abstract class ILocalFavoriteModulesRepository {
  Future<List<Modules>> toggle(Modules module);
  Future<List<Modules>> load();
}
