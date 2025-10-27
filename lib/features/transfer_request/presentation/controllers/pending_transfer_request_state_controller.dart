import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/entities.dart';
import '../../providers.dart';

part 'pending_transfer_request_state_controller.g.dart';

@riverpod
class PendingTransferRequestStateController
    extends _$PendingTransferRequestStateController {
  @override
  Future<List<TransferRequestProductItemEntity>> build(DraftKey draftKey) {
    return ref.watch(localTransferRequestRepositoryProvider).load(draftKey);
  }

  Future<void> addItem(TransferRequestProductItemEntity item) async {
    final repository = ref.read(localTransferRequestRepositoryProvider);

    await repository.addItem(draftKey, item);

    ref.invalidateSelf();

    await future;
  }

  Future<void> removeItem(TransferRequestProductItemEntity item) async {
    final repository = ref.read(localTransferRequestRepositoryProvider);
    await repository.removeItem(draftKey, item);
    ref.invalidateSelf();
    await future;
  }

  Future<void> clearLot() async {
    final repository = ref.read(localTransferRequestRepositoryProvider);
    await repository.clear(draftKey);
    ref.invalidateSelf();
    await future;
  }
}
