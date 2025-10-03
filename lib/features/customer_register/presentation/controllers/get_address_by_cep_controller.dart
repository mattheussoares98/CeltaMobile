import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/domain/entities/entities.dart';
import '../../providers.dart';

part 'get_address_by_cep_controller.g.dart';

@riverpod
class GetAddressByCepController extends _$GetAddressByCepController {
  @override
  FutureOr<AddressEntity?> build() async {
    return null;
  }

  Future<void> getAddress(String cep) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return await ref.read(loadAddressByCepRepositoryProvider).get(cep);
    });
  }
}
