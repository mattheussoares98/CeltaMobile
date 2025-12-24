import '../../../../core/domain/entities/entities.dart';

abstract class IFavoriteModulesRepository {
  Future<List<Modules>> toggle(Modules module);
  Future<List<Modules>> load();
}
