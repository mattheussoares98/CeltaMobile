import '../../../../core/domain/entities/entities.dart';

abstract class ILocalFavoriteModulesDatasource {
  Future<void> toggle(Modules module);
  Future<List<Modules>> load();
}
