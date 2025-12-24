import '../../../../core/domain/entities/entities.dart';

abstract class ILocalFavoriteModulesDatasource {
  Future<List<Modules>> toggle(Modules module);
  Future<List<Modules>> load();
}
