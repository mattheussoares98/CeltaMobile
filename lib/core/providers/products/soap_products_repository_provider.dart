import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/repositories/products/products.dart';
import 'products.dart';

part 'soap_products_repository_provider.g.dart';

@riverpod
ISoapProductsRepository soapProductsRepository(Ref ref) {
  return SoapProductsRepositoryImpl(ref.watch(soapProductsDatasourceProvider));
}
