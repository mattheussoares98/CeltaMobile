import 'package:collection/collection.dart';

import '../../data/datasource/datasource.dart';
import '../../data/models/models.dart';
import '../entities/entities.dart';
import 'repositories.dart';

class LocalCartRepositoryImpl implements ILocalCartRepository {
  final ILocalCartDatasource datasource;
  LocalCartRepositoryImpl(this.datasource);

  @override
  Future<void> addItem(
    DraftKey key,
    TransferRequestProductItemEntity item,
    CartAdditionStrategy additionStrategy,
  ) async {
    double finalQuantity;

    switch (additionStrategy) {
      case CartAdditionStrategy.increase:
        final local = await load(key);
        final existingProduct = local.firstWhereOrNull(
          (e) =>
              e.product.ProductPackingCode == item.product.ProductPackingCode,
        );
        finalQuantity = (existingProduct?.quantity ?? 0) + item.quantity;
        break;
      case CartAdditionStrategy.overwrite:
        finalQuantity = item.quantity;
        break;
    }
    await datasource.addItem(
      key,
      TransferRequestProductItemModel.fromEntity(
        item.copyWith(quantity: finalQuantity),
      ),
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
