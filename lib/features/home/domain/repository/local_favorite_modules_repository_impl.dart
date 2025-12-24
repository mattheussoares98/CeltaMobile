import '../../../../core/domain/entities/entities.dart';
import '../../data/datasource/datasource.dart';
import 'repository.dart';

class LocalFavoriteModulesRepositoryImpl
    implements ILocalFavoriteModulesRepository {
  final ILocalFavoriteModulesDatasource datasource;
  LocalFavoriteModulesRepositoryImpl(this.datasource);

  @override
  Future<void> toggle(Modules module) async {
    await datasource.toggle(module);
  }

  @override
  Future<List<Modules>> load() async {
    return await datasource.load();
  }
}
