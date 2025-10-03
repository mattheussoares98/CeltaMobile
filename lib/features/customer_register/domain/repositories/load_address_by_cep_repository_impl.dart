import 'package:celta_intelligence/core/domain/entities/address/address_entity.dart';

import '../../data/datasource/datasource.dart';
import 'repositories.dart';

class LoadAddressByCepRepositoryImpl implements ILoadAddressByCepRepository {
  final ILoadAddressByCepDatasource datasource;
  LoadAddressByCepRepositoryImpl(this.datasource);

  @override
  Future<AddressEntity?> get(String cep) async {
    final response = await datasource.get(cep);

    return response?.toEntity();
  }
}
