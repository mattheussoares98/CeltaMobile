import 'package:equatable/equatable.dart';

import '../../domain/entities/entities.dart';
import 'models.dart';

class PendingTransferRequestModel extends Equatable {
  final Map<DraftKey, TransferRequestProductItemModel>? products;

  const PendingTransferRequestModel({required this.products});

  @override
  List<Object?> get props => [products];

  factory PendingTransferRequestModel.fromJson(Map json) {
    return PendingTransferRequestModel(
      products: json['products'] == null
          ? null
          : Map.fromEntries(
              (json['products'] as Map).entries.map(
                (entry) => MapEntry(
                  DraftKey.fromMapKey(entry.key),
                  TransferRequestProductItemModel.fromJson(entry.value),
                ),
              ),
            ),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'products': products == null
        ? null
        : Map.fromEntries(
            products!.entries.map(
              (entry) => MapEntry(entry.key.toMapKey(), entry.value.toJson()),
            ),
          ),
  };

  factory PendingTransferRequestModel.fromEntity(
    PendingTransferRequestEntity entity,
  ) {
    return PendingTransferRequestModel(
      products: entity.products == null
          ? null
          : Map.fromEntries(
              entity.products!.entries.map(
                (entry) => MapEntry(
                  entry.key,
                  TransferRequestProductItemModel.fromEntity(entry.value),
                ),
              ),
            ),
    );
  }

  PendingTransferRequestEntity toEntity() {
    return PendingTransferRequestEntity(
      products: products == null
          ? {}
          : Map.fromEntries(
              products!.entries.map(
                (entry) => MapEntry(entry.key, entry.value.toEntity()),
              ),
            ),
    );
  }
}
