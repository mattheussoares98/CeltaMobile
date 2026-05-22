import 'package:celta_inventario/core/domain/entities/address/soap/address_entity.dart';
import 'package:celta_inventario/core/domain/repositories/address/address.dart';

import 'package:celta_inventario/core/data/datasource/address/address.dart';

class LoadAddressByCepRepositoryImpl implements ILoadAddressByCepRepository {
  final ILoadAddressByCepDatasource datasource;
  LoadAddressByCepRepositoryImpl(this.datasource);

  @override
  Future<AddressEntity?> get(String cep) async {
    final response = await datasource.get(cep);

    return response?.toEntity();
  }
}
