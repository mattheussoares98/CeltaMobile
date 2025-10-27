import '../../domain/entities/entities.dart';

abstract class ILocalTransferRequestRepository {
  Future<void> addItem(DraftKey key, TransferRequestProductItemEntity item);
  Future<void> removeItem(DraftKey key, TransferRequestProductItemEntity item);
  Future<List<TransferRequestProductItemEntity>> load(DraftKey key);
  Future<void> clear(DraftKey key);
}
