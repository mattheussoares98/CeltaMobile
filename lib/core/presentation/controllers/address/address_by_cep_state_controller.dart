import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/providers/address/address.dart';

part 'address_by_cep_state_controller.g.dart';

@riverpod
class AddressByCepStateController extends _$AddressByCepStateController {
  @override
  FutureOr<AddressEntity?> build(Modules module) async {
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

  Future<void> getAddress(String cep) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return await ref.read(loadAddressByCepRepositoryProvider).get(cep);
    });
  }

  void updateAddress(AddressEntity address) {
    state = AsyncData(address);
  }
}
