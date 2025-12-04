import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/datasource/products/products.dart';
import '../../domain/repositories/products/products.dart';
import '../soap/soap.dart';

part 'products.g.dart';

@riverpod
ISoapGetProductsJsonDatasource soapGetProductsJsonDatasource(Ref ref) {
  return SoapGetProductsJsonDatasource(ref.watch(soapRequestProvider));
}

@riverpod
ISoapInventoryLoadProductsDatasource soapInventoryLoadProductsDatasource(
  Ref ref,
) {
  return SoapInventoryLoadProductsDatasource(ref.watch(soapRequestProvider));
}

@riverpod
ISoapLoadProductByRequestTypeDatasource soapLoadProductByRequestTypeDatasource(
  Ref ref,
) {
  return SoapLoadProductByRequestTypeDatasource(ref.watch(soapRequestProvider));
}

@riverpod
ISoapReceiptLoadProductsDatasource soapReceiptLoadProductsDatasource(Ref ref) {
  return SoapReceiptLoadProductsDatasource(ref.watch(soapRequestProvider));
}

@riverpod
ISoapLoadProductsRepository soapLoadProductsRepository(Ref ref) {
  return SoapLoadProductsRepositoryImpl(
    ref.watch(soapGetProductsJsonDatasourceProvider),
    ref.watch(soapInventoryLoadProductsDatasourceProvider),
    ref.watch(soapLoadProductByRequestTypeDatasourceProvider),
  );
}
