import 'dart:async';

import 'package:celta_intelligence/features/enterprises/presentation/controllers/controllers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/domain/entities/entities.dart';
import '../../domain/entities/entities.dart';
import '../../domain/repository/repository.dart';
import '../../providers.dart';

part 'pending_sale_request_state_controller.g.dart';

@riverpod
class PendingSaleRequestStateController
    extends _$PendingSaleRequestStateController {
  @override
  Future<PendingSaleRequestEntity> build() async {
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

    final repository = ref.watch(localPendingSaleRequestRepositoryProvider);
    final localData = await repository.load(
      ref.watch(selectedEnterpriseStateControllerProvider)!.Code!,
    );

    return localData ?? PendingSaleRequestEntity.empty();
  }

  ILocalPendingSaleRequestRepository get _repository =>
      ref.read(localPendingSaleRequestRepositoryProvider);

  Future<void> _updateAndSave(PendingSaleRequestEntity newState) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repository.save(
        newState,
        ref.watch(selectedEnterpriseStateControllerProvider)!.Code!,
      );
      return newState;
    });
  }

  Future<void> addProduct(CartProductEntity item) async {
    if (state.value == null) return;

    final newCart = Map.of(state.value!.cart);

    newCart[item.ProductPackingCode] = item;

    await _updateAndSave(state.value!.copyWith(cart: newCart));
  }

  Future<void> removeProduct(CartProductEntity product) async {
    if (state.value == null) return;

    final newCart = Map.of(state.value!.cart);
    newCart.remove(product.ProductPackingCode);

    await _updateAndSave(state.value!.copyWith(cart: newCart));
  }

  Future<void> changeCustomer(CustomerEntity newCustomer) async {
    if (state.value == null) return;

    if (newCustomer.Code == state.value!.customer?.Code) {
      await _updateAndSave(state.value!.annulValues(customer: true));
    } else {
      await _updateAndSave(state.value!.copyWith(customer: newCustomer));
    }
  }
}
