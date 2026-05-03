import '../../../../core/domain/entities/entities.dart';
import '../datasource/datasource.dart';
import 'package:celta_inventario/features/home/domain/repository/repository.dart';

class LocalFavoriteModulesRepositoryImpl implements IFavoriteModulesRepository {
  final IFavoriteModulesDatasource datasource;
  LocalFavoriteModulesRepositoryImpl(this.datasource);

  @override
  Future<List<Modules>> toggle(Modules module) async {
    return await datasource.toggle(module);
  }

  @override
  Future<List<Modules>> load() async {
    return await datasource.load();
  }
}
