import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:celta_inventario/core/data/datasource/products/products.dart';
import 'package:celta_inventario/core/domain/repositories/products/products.dart';
import 'package:celta_inventario/core/data/repositories/products/products.dart';
import 'package:celta_inventario/core/providers/http/http.dart';
import 'package:celta_inventario/core/providers/soap/soap.dart';

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
    ref.watch(soapReceiptLoadProductsDatasourceProvider),
  );
}

@riverpod
IEcGetShallowProductsDatasource ecGetShallowProductsDatasource(Ref ref) {
  return EcGetShallowProductsDatasource(ref.watch(httpClientProvider));
}

@riverpod
IEcGetShallowProductsRepository ecGetShallowProductsRepository(Ref ref) {
  return EcGetShallowProductsRepositoryImpl(
    ref.watch(ecGetShallowProductsDatasourceProvider),
  );
}
