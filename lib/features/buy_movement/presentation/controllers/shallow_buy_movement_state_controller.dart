import 'dart:async';

import 'package:celta_inventario/core/providers/ec_request_params/ec_request_params.dart';
import 'package:celta_inventario/exceptions/exceptions.dart';
import 'package:celta_inventario/features/buy_movement/domain/entities/entities.dart';
import 'package:celta_inventario/features/buy_movement/providers.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'shallow_buy_movement_state_controller.g.dart';

@riverpod
class ShallowBuyMovementStateController
    extends _$ShallowBuyMovementStateController {
  @override
  FutureOr<List<EcBuyMovementDtoEntity>?> build(int enterpriseCode) {
    Timer? timer;
    final link = ref.keepAlive();
    ref.onCancel(() {
      timer = Timer(const Duration(seconds: 20), () {
        link.close();
      });
    });
    ref.onResume(() {
      timer?.cancel();
    });
    ref.onDispose(() {
      timer?.cancel();
    });

    return null;
  }

  Future<void> load(DateTime initialDate, DateTime finalDate) async {
    final ecParams = await ref.read(ecRequestParamsProvider().future);

    if (initialDate.difference(finalDate).inDays.abs() > 90) {
      throw AppException(
        'A diferença do período não pode ser maior que 90 dias'.hardcoded,
      );
    }
    LoadShallowBuyMovementParams params = LoadShallowBuyMovementParams(
      requestParams: ecParams,
      selectedDate: initialDate,
      finalDate: finalDate,
      enterpriseCode: enterpriseCode,
    );

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final result = await ref
          .read(ecBuyMovementRepositoryProvider)
          .loadShallow(params);

      return result;
    });
  }
}
