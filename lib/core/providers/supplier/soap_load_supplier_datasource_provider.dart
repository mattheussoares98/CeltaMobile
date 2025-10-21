import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/datasource/supplier/supplier.dart';
import '../soap/soap.dart';

part 'soap_load_supplier_datasource_provider.g.dart';

@riverpod
ISoapLoadSupplierDatasource soapLoadSupplierDatasource(Ref ref) {
  return SoapLoadSupplierDatasource(ref.watch(soapRequestProvider));
}
