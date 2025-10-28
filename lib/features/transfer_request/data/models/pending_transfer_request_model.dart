import 'package:equatable/equatable.dart';

import '../../domain/entities/entities.dart';
import 'models.dart';

class PendingTransferRequestModel extends Equatable {
  final List<TransferRequestProductItemModel>? products;
  final String? lastSavedRequestNumber;

  const PendingTransferRequestModel({
    required this.products,
    required this.lastSavedRequestNumber,
  });

  @override
  List<Object?> get props => [products];

  factory PendingTransferRequestModel.fromJson(Map json) {
    return PendingTransferRequestModel(
      products: json['products']
          ?.map((e) => TransferRequestProductItemModel.fromJson(e))
          .toList(),
      lastSavedRequestNumber: json['lastSavedRequestNumber'],
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'products': products?.map((e) => e.toJson()).toList(),
    'lastSavedRequestNumber': lastSavedRequestNumber,
  };

  factory PendingTransferRequestModel.fromEntity(
    PendingTransferRequestEntity entity,
  ) {
    return PendingTransferRequestModel(
      products: entity.products
          ?.map((e) => TransferRequestProductItemModel.fromEntity(e))
          .toList(),
      lastSavedRequestNumber: entity.lastSavedRequestNumber,
    );
  }

  PendingTransferRequestEntity toEntity() {
    return PendingTransferRequestEntity(
      products: products?.map((e) => e.toEntity()).toList(),
      lastSavedRequestNumber: lastSavedRequestNumber,
    );
  }
}
