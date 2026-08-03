import 'dart:async';

import 'package:celta_inventario/exceptions/exceptions.dart';
import 'package:celta_inventario/features/buy_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/buy_request/providers.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/providers/ec_request_params/ec_request_params.dart';

part 'shallow_buy_request_state_controller.g.dart';

@riverpod
class ShallowBuyRequestStateController
    extends _$ShallowBuyRequestStateController {
  @override
  FutureOr<List<EcBuyRequestDtoEntity>?> build(int enterpriseCode) {
    ref.cache();

    return null;
  }

  Future<void> load(DateTime initialDate, DateTime finalDate) async {
    final ecParams = await ref.read(ecRequestParamsProvider().future);

    if (initialDate.difference(finalDate).inDays.abs() > 90) {
      throw AppException(
        'A diferença entre as datas não pode ser maior que 90 dias',
      );
    }

    LoadShallowBuyRequestParams params = LoadShallowBuyRequestParams(
      requestParams: ecParams,
      selectedDate: initialDate,
      finalDate: finalDate,
      enterpriseCode: enterpriseCode,
    );

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final result = await ref
          .read(ecBuyRequestRepositoryProvider)
          .loadShallow(params);

      return result;
    });
  }
}
