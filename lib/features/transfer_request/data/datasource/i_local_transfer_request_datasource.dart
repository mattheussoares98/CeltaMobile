import '../../domain/entities/entities.dart';
import '../models/models.dart';

abstract class ILocalTransferRequestDatasource {
  Future<void> addItem(DraftKey key, TransferRequestProductItemModel item);
  Future<void> removeItem(DraftKey key, TransferRequestProductItemModel item);
  Future<List<TransferRequestProductItemModel>> load(DraftKey key);
  Future<void> clear(DraftKey key);
}
