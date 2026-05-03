import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/providers/soap/soap.dart';
import 'data/datasource/datasource.dart';
import 'domain/repositories/repositories.dart';
import 'data/repositories/repositories.dart';

part 'providers.g.dart';

@riverpod
ISoapAdjustSalePriceDatasource soapAdjustSalePriceDatasource(Ref ref) {
  return SoapAdjustSalePriceDatasource(
    soapRequest: ref.watch(soapRequestProvider),
  );
}

@riverpod
ISoapAdjustSalePriceRepository soapAdjustSalePriceRepository(Ref ref) {
  return SoapAdjustSalePriceRepositoryImpl(
    soapAdjustSalePriceDatasource: ref.watch(
      soapAdjustSalePriceDatasourceProvider,
    ),
  );
}

@riverpod
ISoapGetPriceSchedulesDatasource soapGetPriceSchedulesDatasource(Ref ref) {
  return SoapGetPriceSchedulesDatasource(
    soapRequest: ref.watch(soapRequestProvider),
  );
}

@riverpod
ISoapGetPriceSchedulesRepository soapGetPriceSchedulesRepository(Ref ref) {
  return SoapGetPriceSchedulesRepositoryImpl(
    soapGetPriceSchedulesDatasource: ref.watch(
      soapGetPriceSchedulesDatasourceProvider,
    ),
  );
}
