import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/entities.dart';
import '../../providers.dart';

part 'confirm_adjust_controller.g.dart';

@riverpod
class ConfirmAdjustController extends _$ConfirmAdjustController {
  @override
  FutureOr<void> build() {}

  Future<void> confirm({
    required String baseUrl,
    required String crossIdentity,
    required int enterpriseCode,
    required int productCode,
    required int productPackingCode,
    required SaleType saleType,
    required List<ReplicationTypes> replications,
    required OfferParams? offerParams,
    required RetailParams? retailParams,
    required DateTime now,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref
          .read(soapAdjustSalePriceRepositoryProvider)
          .confirm(
            baseUrl: baseUrl,
            crossIdentity: crossIdentity,
            enterpriseCode: enterpriseCode,
            productCode: productCode,
            productPackingCode: productPackingCode,
            saleType: saleType,
            replications: replications,
            offerParams: offerParams,
            retailParams: retailParams,
            now: now,
          );
    });
  }
}
