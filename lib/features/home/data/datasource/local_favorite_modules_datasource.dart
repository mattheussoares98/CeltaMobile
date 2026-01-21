import 'package:celta_inventario/core/domain/entities/modules.dart';
import 'package:hive/hive.dart';

import '../../../../core/infraestructure/infrastructure.dart';
import 'datasource.dart';

class LocalFavoriteModulesDatasource implements IFavoriteModulesDatasource {
  final Box box;
  LocalFavoriteModulesDatasource(this.box);

  @override
  Future<List<Modules>> toggle(Modules module) async {
    final localModules = await load();

    if (localModules.contains(module)) {
      localModules.remove(module);
    } else {
      localModules.add(module);
    }
    await _saveModules(localModules);
    return localModules;
  }

  @override
  Future<List<Modules>> load() async {
    final response = await box.get(DatabaseConstants.favoriteModules.name);

    if (response == null) {
      return [];
    } else {
      return (response as List)
          .map((e) => Modules.values.firstWhere((element) => element.name == e))
          .toList();
    }
  }

  Future<void> _saveModules(List<Modules> modules) async {
    await box.put(
      DatabaseConstants.favoriteModules.name,
      modules.map((e) => e.name).toList(),
    );
  }
}
