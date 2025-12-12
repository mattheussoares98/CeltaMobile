import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/providers/soap/soap.dart';
import 'data/datasource/datasource.dart';

part 'providers.g.dart';

@riverpod
ISoapLoadBuyQuotationsDatasource soapLoadBuyQuotationsDatasource(Ref ref) {
  return SoapLoadBuyQuotationsDatasource(ref.watch(soapRequestProvider));
}
