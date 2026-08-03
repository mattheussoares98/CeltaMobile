import 'dart:async';

import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/providers/address/address.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'address_by_cep_state_controller.g.dart';

@riverpod
class AddressByCepStateController extends _$AddressByCepStateController {
  @override
  FutureOr<AddressEntity?> build(Modules module) async {
    ref.cache();

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
