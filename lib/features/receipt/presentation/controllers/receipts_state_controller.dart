import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/features/receipt/domain/entity/entity.dart';
import 'package:celta_inventario/features/receipt/providers.dart';

part 'receipts_state_controller.g.dart';

@riverpod
class ReceiptsStateController extends _$ReceiptsStateController {
  @override
  FutureOr<List<ReceiptEntity>> build(int enterpriseCode) async {
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

    final validatedUser = await ref.watch(validatedUserSessionProvider.future);

    return await ref
        .read(soapLoadReceiptsRepositoryProvider)
        .loadReceipts(
          workingUrl: validatedUser!.enterprise!.workingUrl!,
          crossIdentity: validatedUser.user.CrossIdentity_Usuario!,
          enterpriseCode: enterpriseCode,
        );
  }

  Future<void> updateObservationsLocally(
    String observations,
    int CodigoInterno_ProcRecebDoc,
  ) async {
    if (state.value == null || state.value!.isEmpty) return;
    state = await AsyncValue.guard(() async {
      final receiptIndex = state.value!.indexWhere(
        (e) => e.CodigoInterno_ProcRecebDoc == CodigoInterno_ProcRecebDoc,
      );

      final receipt = state.value![receiptIndex].copyWith(
        Observacoes_ProcRecebDoc: observations,
      );

      final updatedList = List<ReceiptEntity>.from(state.value!);
      updatedList[receiptIndex] = receipt;

      return updatedList;
    });
  }
}
