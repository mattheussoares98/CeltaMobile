import 'package:celta_inventario/features/synchronizer/data/models/models.dart';
import 'package:celta_inventario/features/synchronizer/domain/entities/entities.dart';

class EcSynchronizerErrorDetailsModel extends SynchronizerErrorDetailsEntity {
  const EcSynchronizerErrorDetailsModel({
    required super.category,
    required super.errorKey,
    required super.detailType,
    required super.items,
  });

  factory EcSynchronizerErrorDetailsModel.fromJson(Map json) {
    final detailType = SynchronizerErrorDetailType.fromValue(
      json['DetailType'] as int,
    );
    return EcSynchronizerErrorDetailsModel(
      category: json['Category'] as String,
      errorKey: json['ErrorKey'] as String,
      detailType: detailType,
      items: (json['Items'] as List)
          .map((item) => _detailFromJson(detailType, item as Map))
          .toList(),
    );
  }

  Map toJson() => {
    'Category': category,
    'ErrorKey': errorKey,
    'DetailType': detailType.value,
    'Items': items.map(_detailToJson).toList(),
  };

  factory EcSynchronizerErrorDetailsModel.fromEntity(
    SynchronizerErrorDetailsEntity entity,
  ) => EcSynchronizerErrorDetailsModel(
    category: entity.category,
    errorKey: entity.errorKey,
    detailType: entity.detailType,
    items: entity.items.map(_detailFromEntity).toList(),
  );

  SynchronizerErrorDetailsEntity toEntity() => SynchronizerErrorDetailsEntity(
    category: category,
    errorKey: errorKey,
    detailType: detailType,
    items: items.map(_detailToEntity).toList(),
  );

  static EcSynchronizerErrorDetailEntity _detailFromJson(
    SynchronizerErrorDetailType detailType,
    Map json,
  ) {
    switch (detailType) {
      case SynchronizerErrorDetailType.coupon:
        return EcCouponSynchronizerErrorDetailModel.fromJson(json);
      case SynchronizerErrorDetailType.couponMarkedToReadAgain:
        return EcCouponMarkedToReadSynchronizerErrorDetailModel.fromJson(json);
      case SynchronizerErrorDetailType.cashierMovement:
        return EcCashierMovementSynchronizerErrorDetailModel.fromJson(json);
      case SynchronizerErrorDetailType.fiscalNote:
        return EcFiscalNoteSynchronizerErrorDetailModel.fromJson(json);
      case SynchronizerErrorDetailType.nFeDisable:
        return EcNFeDisableSynchronizerErrorDetailModel.fromJson(json);
      case SynchronizerErrorDetailType.schedule:
        return EcScheduleSynchronizerErrorDetailModel.fromJson(json);
      case SynchronizerErrorDetailType.transaction:
        return EcTransactionSynchronizerErrorDetailModel.fromJson(json);
      case SynchronizerErrorDetailType.treasuryMovement:
        return EcTreasuryMovementSynchronizerErrorDetailModel.fromJson(json);
      case SynchronizerErrorDetailType.mapSummarySaleEcf:
        return EcMapSummarySaleEcfSynchronizerErrorDetailModel.fromJson(json);
      case SynchronizerErrorDetailType.customerWithError:
        return EcCustomerWithErrorSynchronizerErrorDetailModel.fromJson(json);
      case SynchronizerErrorDetailType.customerWaitingApproval:
        return EcCustomerWaitingApprovalSynchronizerErrorDetailModel.fromJson(
          json,
        );
      case SynchronizerErrorDetailType.saleRequestWithError:
        return EcSaleRequestWithErrorSynchronizerErrorDetailModel.fromJson(
          json,
        );
      case SynchronizerErrorDetailType.saleRequestWaitingApproval:
        return EcSaleRequestWaitingApprovalSynchronizerErrorDetailModel.fromJson(
          json,
        );
      case SynchronizerErrorDetailType.saleRequestMarked:
        return EcSaleRequestMarkedSynchronizerErrorDetailModel.fromJson(json);
      case SynchronizerErrorDetailType.productWithError:
        return EcProductWithErrorSynchronizerErrorGroupModel.fromJson(json);
      case SynchronizerErrorDetailType.readBleeding:
        return EcReadBleedingSynchronizerErrorDetailModel.fromJson(json);
      case SynchronizerErrorDetailType.correspondentBanking:
        return EcCorrespondentBankingSynchronizerErrorDetailModel.fromJson(
          json,
        );
      case SynchronizerErrorDetailType.saleMovementScanntechLoad:
        return EcSaleMovementScanntechLoadSynchronizerErrorDetailModel.fromJson(
          json,
        );
      case SynchronizerErrorDetailType.sendData:
        return EcSendDataSynchronizerErrorDetailModel.fromJson(json);
    }
  }

  static EcSynchronizerErrorDetailEntity _detailFromEntity(
    EcSynchronizerErrorDetailEntity entity,
  ) {
    if (entity is EcCouponSynchronizerErrorDetailEntity) {
      return EcCouponSynchronizerErrorDetailModel.fromEntity(entity);
    }
    if (entity is EcCouponMarkedToReadSynchronizerErrorDetailEntity) {
      return EcCouponMarkedToReadSynchronizerErrorDetailModel.fromEntity(
        entity,
      );
    }
    if (entity is EcCashierMovementSynchronizerErrorDetailEntity) {
      return EcCashierMovementSynchronizerErrorDetailModel.fromEntity(entity);
    }
    if (entity is EcFiscalNoteSynchronizerErrorDetailEntity) {
      return EcFiscalNoteSynchronizerErrorDetailModel.fromEntity(entity);
    }
    if (entity is EcNFeDisableSynchronizerErrorDetailEntity) {
      return EcNFeDisableSynchronizerErrorDetailModel.fromEntity(entity);
    }
    if (entity is EcScheduleSynchronizerErrorDetailEntity) {
      return EcScheduleSynchronizerErrorDetailModel.fromEntity(entity);
    }
    if (entity is EcTransactionSynchronizerErrorDetailEntity) {
      return EcTransactionSynchronizerErrorDetailModel.fromEntity(entity);
    }
    if (entity is EcTreasuryMovementSynchronizerErrorDetailEntity) {
      return EcTreasuryMovementSynchronizerErrorDetailModel.fromEntity(entity);
    }
    if (entity is EcMapSummarySaleEcfSynchronizerErrorDetailEntity) {
      return EcMapSummarySaleEcfSynchronizerErrorDetailModel.fromEntity(entity);
    }
    if (entity is EcCustomerWithErrorSynchronizerErrorDetailEntity) {
      return EcCustomerWithErrorSynchronizerErrorDetailModel.fromEntity(entity);
    }
    if (entity is EcCustomerWaitingApprovalSynchronizerErrorDetailEntity) {
      return EcCustomerWaitingApprovalSynchronizerErrorDetailModel.fromEntity(
        entity,
      );
    }
    if (entity is EcSaleRequestWithErrorSynchronizerErrorDetailEntity) {
      return EcSaleRequestWithErrorSynchronizerErrorDetailModel.fromEntity(
        entity,
      );
    }
    if (entity is EcSaleRequestWaitingApprovalSynchronizerErrorDetailEntity) {
      return EcSaleRequestWaitingApprovalSynchronizerErrorDetailModel.fromEntity(
        entity,
      );
    }
    if (entity is EcSaleRequestMarkedSynchronizerErrorDetailEntity) {
      return EcSaleRequestMarkedSynchronizerErrorDetailModel.fromEntity(entity);
    }
    if (entity is EcProductWithErrorSynchronizerErrorGroupEntity) {
      return EcProductWithErrorSynchronizerErrorGroupModel.fromEntity(entity);
    }
    if (entity is EcProductWithErrorSynchronizerErrorDetailEntity) {
      return EcProductWithErrorSynchronizerErrorDetailModel.fromEntity(entity);
    }
    if (entity is EcReadBleedingSynchronizerErrorDetailEntity) {
      return EcReadBleedingSynchronizerErrorDetailModel.fromEntity(entity);
    }
    if (entity is EcCorrespondentBankingSynchronizerErrorDetailEntity) {
      return EcCorrespondentBankingSynchronizerErrorDetailModel.fromEntity(
        entity,
      );
    }
    if (entity is EcSaleMovementScanntechLoadSynchronizerErrorDetailEntity) {
      return EcSaleMovementScanntechLoadSynchronizerErrorDetailModel.fromEntity(
        entity,
      );
    }
    if (entity is EcSendDataSynchronizerErrorDetailEntity) {
      return EcSendDataSynchronizerErrorDetailModel.fromEntity(entity);
    }
    throw ArgumentError.value(entity, 'Entity', 'Unsupported detail entity');
  }

  static Map _detailToJson(EcSynchronizerErrorDetailEntity detail) {
    final model = _detailFromEntity(detail);
    if (model is EcCouponSynchronizerErrorDetailModel) return model.toJson();
    if (model is EcCouponMarkedToReadSynchronizerErrorDetailModel) {
      return model.toJson();
    }
    if (model is EcCashierMovementSynchronizerErrorDetailModel) {
      return model.toJson();
    }
    if (model is EcFiscalNoteSynchronizerErrorDetailModel) {
      return model.toJson();
    }
    if (model is EcNFeDisableSynchronizerErrorDetailModel) {
      return model.toJson();
    }
    if (model is EcScheduleSynchronizerErrorDetailModel) return model.toJson();
    if (model is EcTransactionSynchronizerErrorDetailModel) {
      return model.toJson();
    }
    if (model is EcTreasuryMovementSynchronizerErrorDetailModel) {
      return model.toJson();
    }
    if (model is EcMapSummarySaleEcfSynchronizerErrorDetailModel) {
      return model.toJson();
    }
    if (model is EcCustomerWithErrorSynchronizerErrorDetailModel) {
      return model.toJson();
    }
    if (model is EcCustomerWaitingApprovalSynchronizerErrorDetailModel) {
      return model.toJson();
    }
    if (model is EcSaleRequestWithErrorSynchronizerErrorDetailModel) {
      return model.toJson();
    }
    if (model is EcSaleRequestWaitingApprovalSynchronizerErrorDetailModel) {
      return model.toJson();
    }
    if (model is EcSaleRequestMarkedSynchronizerErrorDetailModel) {
      return model.toJson();
    }
    if (model is EcProductWithErrorSynchronizerErrorGroupModel) {
      return model.toJson();
    }
    if (model is EcProductWithErrorSynchronizerErrorDetailModel) {
      return model.toJson();
    }
    if (model is EcReadBleedingSynchronizerErrorDetailModel) {
      return model.toJson();
    }
    if (model is EcCorrespondentBankingSynchronizerErrorDetailModel) {
      return model.toJson();
    }
    if (model is EcSaleMovementScanntechLoadSynchronizerErrorDetailModel) {
      return model.toJson();
    }
    if (model is EcSendDataSynchronizerErrorDetailModel) return model.toJson();
    throw StateError('Unsupported detail model: ${model.runtimeType}');
  }

  static EcSynchronizerErrorDetailEntity _detailToEntity(
    EcSynchronizerErrorDetailEntity detail,
  ) {
    final model = _detailFromEntity(detail);
    if (model is EcCouponSynchronizerErrorDetailModel) return model.toEntity();
    if (model is EcCouponMarkedToReadSynchronizerErrorDetailModel) {
      return model.toEntity();
    }
    if (model is EcCashierMovementSynchronizerErrorDetailModel) {
      return model.toEntity();
    }
    if (model is EcFiscalNoteSynchronizerErrorDetailModel) {
      return model.toEntity();
    }
    if (model is EcNFeDisableSynchronizerErrorDetailModel) {
      return model.toEntity();
    }
    if (model is EcScheduleSynchronizerErrorDetailModel) {
      return model.toEntity();
    }
    if (model is EcTransactionSynchronizerErrorDetailModel) {
      return model.toEntity();
    }
    if (model is EcTreasuryMovementSynchronizerErrorDetailModel) {
      return model.toEntity();
    }
    if (model is EcMapSummarySaleEcfSynchronizerErrorDetailModel) {
      return model.toEntity();
    }
    if (model is EcCustomerWithErrorSynchronizerErrorDetailModel) {
      return model.toEntity();
    }
    if (model is EcCustomerWaitingApprovalSynchronizerErrorDetailModel) {
      return model.toEntity();
    }
    if (model is EcSaleRequestWithErrorSynchronizerErrorDetailModel) {
      return model.toEntity();
    }
    if (model is EcSaleRequestWaitingApprovalSynchronizerErrorDetailModel) {
      return model.toEntity();
    }
    if (model is EcSaleRequestMarkedSynchronizerErrorDetailModel) {
      return model.toEntity();
    }
    if (model is EcProductWithErrorSynchronizerErrorGroupModel) {
      return model.toEntity();
    }
    if (model is EcProductWithErrorSynchronizerErrorDetailModel) {
      return model.toEntity();
    }
    if (model is EcReadBleedingSynchronizerErrorDetailModel) {
      return model.toEntity();
    }
    if (model is EcCorrespondentBankingSynchronizerErrorDetailModel) {
      return model.toEntity();
    }
    if (model is EcSaleMovementScanntechLoadSynchronizerErrorDetailModel) {
      return model.toEntity();
    }
    if (model is EcSendDataSynchronizerErrorDetailModel) {
      return model.toEntity();
    }
    throw StateError('Unsupported detail model: ${model.runtimeType}');
  }
}
