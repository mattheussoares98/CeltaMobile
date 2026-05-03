import 'package:celta_inventario/core/domain/entities/supplier/search_supplier_type.dart';

import 'package:celta_inventario/core/domain/entities/supplier/supplier_entity.dart';

import '../../../data/datasource/supplier/supplier.dart';
import 'package:celta_inventario/core/domain/repositories/supplier/supplier.dart';

class SoapLoadSupplierRepositoryImpl implements ISoapLoadSupplierRepository {
  final ISoapLoadSupplierDatasource datasource;
  SoapLoadSupplierRepositoryImpl(this.datasource);

  @override
  Future<List<SupplierEntity>> load({
    required String workingUrl,
    required String crossIdentity,
    required SearchSupplierType searchType,
    required String searchValue,
  }) async {
    final result = await datasource.load(
      workingUrl: workingUrl,
      crossIdentity: crossIdentity,
      searchType: searchType,
      searchValue: searchValue,
    );
    return result.map((e) => e.toEntity()).toList();
  }
}
