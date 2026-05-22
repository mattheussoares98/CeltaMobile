import 'package:celta_inventario/features/transfer_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/transfer_request/data/models/models.dart';

abstract class ILocalCartDatasource {
  Future<void> addItem(DraftKey key, TransferRequestProductItemModel item);
  Future<void> removeItem(DraftKey key, TransferRequestProductItemModel item);
  Future<List<TransferRequestProductItemModel>> load(DraftKey key);
  Future<void> clear(DraftKey key);
}
