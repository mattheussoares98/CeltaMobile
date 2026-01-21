import 'package:celta_inventario/features/transfer_request/domain/entities/draft_key.dart';

import 'package:celta_inventario/features/transfer_request/domain/entities/transfer_request_product_item_entity.dart';

import '../../data/datasource/datasource.dart';
import '../../data/models/models.dart';
import 'repositories.dart';

class LocalCartRepositoryImpl implements ILocalCartRepository {
  final ILocalCartDatasource datasource;
  LocalCartRepositoryImpl(this.datasource);

  @override
  Future<void> addItem(
    DraftKey key,
    TransferRequestProductItemEntity item,
  ) async {
    await datasource.addItem(
      key,
      TransferRequestProductItemModel.fromEntity(item),
    );
  }

  @override
  Future<void> clear(DraftKey key) async {
    await datasource.clear(key);
  }

  @override
  Future<List<TransferRequestProductItemEntity>> load(DraftKey key) async {
    final items = await datasource.load(key);
    return items.map((e) => e.toEntity()).toList();
  }

  @override
  Future<void> removeItem(
    DraftKey key,
    TransferRequestProductItemEntity item,
  ) async {
    await datasource.removeItem(
      key,
      TransferRequestProductItemModel.fromEntity(item),
    );
  }
}
