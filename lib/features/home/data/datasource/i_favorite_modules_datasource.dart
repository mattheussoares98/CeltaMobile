import 'package:celta_inventario/core/domain/entities/entities.dart';

abstract class IFavoriteModulesDatasource {
  Future<List<Modules>> toggle(Modules module);
  Future<List<Modules>> load();
}
