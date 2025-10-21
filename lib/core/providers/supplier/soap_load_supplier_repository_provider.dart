import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/repositories/supplier/supplier.dart';
import 'supplier.dart';

part 'soap_load_supplier_repository_provider.g.dart';

@riverpod
ISoapLoadSupplierRepository soapLoadSupplierRepository(Ref ref) {
  return SoapLoadSupplierRepositoryImpl(
    ref.watch(soapLoadSupplierDatasourceProvider),
  );
}
