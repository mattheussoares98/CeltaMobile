import 'package:celta_inventario/features/transfer_request/domain/entities/entities.dart';

abstract class ILocalCartRepository {
  Future<void> addItem(
    DraftKey key,
    TransferRequestProductItemEntity item,
    CartAdditionStrategy additionStrategy,
  );
  Future<void> removeItem(DraftKey key, TransferRequestProductItemEntity item);
  Future<List<TransferRequestProductItemEntity>> load(DraftKey key);
  Future<void> clear(DraftKey key);
}
