import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:celta_inventario/core/data/datasource/buyer/buyer.dart';
import 'package:celta_inventario/core/domain/repositories/buyer/buyer.dart';
import 'package:celta_inventario/core/data/repositories/buyer/buyer.dart';
import 'package:celta_inventario/core/providers/soap/soap.dart';

part 'buyer.g.dart';

@riverpod
ISoapLoadBuyersDatasource soapLoadBuyersDatasource(Ref ref) {
  return SoapLoadBuyersDatasource(ref.watch(soapRequestProvider));
}

@riverpod
ISoapLoadBuyersRepository soapLoadBuyersRepository(Ref ref) {
  return SoapLoadBuyersRepositoryImpl(
    ref.watch(soapLoadBuyersDatasourceProvider),
  );
}
