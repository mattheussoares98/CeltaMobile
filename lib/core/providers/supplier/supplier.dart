import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:celta_inventario/core/data/datasource/supplier/supplier.dart';
import 'package:celta_inventario/core/domain/repositories/supplier/supplier.dart';
import 'package:celta_inventario/core/data/repositories/supplier/supplier.dart';
import 'package:celta_inventario/core/providers/soap/soap.dart';

part 'supplier.g.dart';

@riverpod
ISoapLoadSupplierDatasource soapLoadSupplierDatasource(Ref ref) {
  return SoapLoadSupplierDatasource(ref.watch(soapRequestProvider));
}

@riverpod
ISoapLoadSupplierRepository soapLoadSupplierRepository(Ref ref) {
  return SoapLoadSupplierRepositoryImpl(
    ref.watch(soapLoadSupplierDatasourceProvider),
  );
}
