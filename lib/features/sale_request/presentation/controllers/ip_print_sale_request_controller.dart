import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../providers.dart';

part 'ip_print_sale_request_controller.g.dart';

@riverpod
class IpPrintSaleRequestController extends _$IpPrintSaleRequestController {
  @override
  FutureOr<String?> build() async {
    return await ref.watch(localIpPrintSaleRequestRepositoryProvider).load();
  }

  Future<void> udpate(String ip) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(localIpPrintSaleRequestRepositoryProvider).save(ip);

      return ip;
    });
  }
}
