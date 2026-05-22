import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:celta_inventario/core/providers/soap/soap.dart';
import 'package:celta_inventario/features/adjust_sale_price/data/datasource/datasource.dart';
import 'package:celta_inventario/features/adjust_sale_price/domain/repositories/repositories.dart';
import 'package:celta_inventario/features/adjust_sale_price/data/repositories/repositories.dart';

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
