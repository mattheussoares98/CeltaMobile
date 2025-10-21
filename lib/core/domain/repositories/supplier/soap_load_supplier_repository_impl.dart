import 'package:celta_intelligence/core/domain/entities/supplier/search_supplier_type.dart';

import 'package:celta_intelligence/core/domain/entities/supplier/supplier_entity.dart';

import '../../../data/datasource/supplier/supplier.dart';
import 'supplier.dart';

class SoapLoadSupplierRepositoryImpl implements ISoapLoadSupplierRepository {
  final ISoapLoadSupplierDatasource datasource;
  SoapLoadSupplierRepositoryImpl(this.datasource);

  @override
  Future<List<SupplierEntity>> load({
    required String baseUrl,
    required String crossIdentity,
    required SearchSupplierType searchType,
    required String searchValue,
  }) async {
    final result = await datasource.load(
      baseUrl: baseUrl,
      crossIdentity: crossIdentity,
      searchType: searchType,
      searchValue: searchValue,
    );
    return result.map((e) => e.toEntity()).toList();
  }
}
