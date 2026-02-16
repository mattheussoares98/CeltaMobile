import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/datasource/supplier/supplier.dart';
import '../../domain/repositories/supplier/supplier.dart';
import '../soap/soap.dart';

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
