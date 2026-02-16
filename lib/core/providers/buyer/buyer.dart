import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/datasource/buyer/buyer.dart';
import '../../domain/repositories/buyer/buyer.dart';
import '../soap/soap.dart';

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
