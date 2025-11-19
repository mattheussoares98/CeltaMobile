import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/domain/entities/entities.dart';
import '../../../../core/providers/address/address.dart';

part 'get_address_by_cep_controller.g.dart';

@riverpod
class GetAddressByCepController extends _$GetAddressByCepController {
  @override
  FutureOr<AddressEntity?> build() async {
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
}
