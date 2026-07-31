import 'package:celta_inventario/features/synchronizer/data/models/models.dart';
import 'package:celta_inventario/features/synchronizer/domain/entities/entities.dart';

class SynchronizerErrorDetailsModel extends SynchronizerErrorDetailsEntity {
  const SynchronizerErrorDetailsModel({
    required super.category,
    required super.errorKey,
    required super.detailType,
    required super.items,
  });

  factory SynchronizerErrorDetailsModel.fromJson(Map json) {
    final detailType = SynchronizerErrorDetailType.fromValue(
      json['detailType'] as int,
    );
    return SynchronizerErrorDetailsModel(
      category: json['category'] as String,
      errorKey: json['errorKey'] as String,
      detailType: detailType,
      items: (json['items'] as List)
          .map((item) => _detailFromJson(detailType, item as Map))
          .toList(),
    );
  }

  Map toJson() => {
    'category': category,
    'errorKey': errorKey,
    'detailType': detailType.value,
    'items': items.map(_detailToJson).toList(),
  };

  factory SynchronizerErrorDetailsModel.fromEntity(
    SynchronizerErrorDetailsEntity entity,
  ) => SynchronizerErrorDetailsModel(
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

  static SynchronizerErrorDetailEntity _detailFromJson(
    SynchronizerErrorDetailType detailType,
    Map json,
  ) {
    switch (detailType) {
      case SynchronizerErrorDetailType.coupon:
        return BSFCouponSynchronizerErrorDetailModel.fromJson(json);
      case SynchronizerErrorDetailType.cashierMovement:
        return BSFCashierMovementSynchronizerErrorDetailModel.fromJson(json);
      case SynchronizerErrorDetailType.fiscalNote:
        return BSFFiscalNoteSynchronizerErrorDetailModel.fromJson(json);
      case SynchronizerErrorDetailType.nFeDisable:
        return BSFNFeDisableSynchronizerErrorDetailModel.fromJson(json);
      case SynchronizerErrorDetailType.schedule:
        return BSFScheduleSynchronizerErrorDetailModel.fromJson(json);
      case SynchronizerErrorDetailType.transaction:
        return BSFTransactionSynchronizerErrorDetailModel.fromJson(json);
      case SynchronizerErrorDetailType.treasuryMovement:
        return BSFTreasuryMovementSynchronizerErrorDetailModel.fromJson(json);
      case SynchronizerErrorDetailType.mapSummarySaleEcf:
        return BSFMapSummarySaleEcfSynchronizerErrorDetailModel.fromJson(json);
      case SynchronizerErrorDetailType.customerWithError:
        return BSFCustomerWithErrorSynchronizerErrorDetailModel.fromJson(json);
      case SynchronizerErrorDetailType.customerWaitingApproval:
        return BSFCustomerWaitingApprovalSynchronizerErrorDetailModel.fromJson(
          json,
        );
      case SynchronizerErrorDetailType.saleRequestWithError:
        return BSFSaleRequestWithErrorSynchronizerErrorDetailModel.fromJson(
          json,
        );
      case SynchronizerErrorDetailType.saleRequestWaitingApproval:
        return BSFSaleRequestWaitingApprovalSynchronizerErrorDetailModel.fromJson(
          json,
        );
      case SynchronizerErrorDetailType.saleRequestMarked:
        return BSFSaleRequestMarkedSynchronizerErrorDetailModel.fromJson(json);
      case SynchronizerErrorDetailType.productWithError:
        return BSFProductWithErrorSynchronizerErrorDetailModel.fromJson(json);
      case SynchronizerErrorDetailType.readBleeding:
        return BSFReadBleedingSynchronizerErrorDetailModel.fromJson(json);
      case SynchronizerErrorDetailType.correspondentBanking:
        return BSFCorrespondentBankingSynchronizerErrorDetailModel.fromJson(
          json,
        );
      case SynchronizerErrorDetailType.saleMovementScanntechLoad:
        return BSFSaleMovementScanntechLoadSynchronizerErrorDetailModel.fromJson(
          json,
        );
      case SynchronizerErrorDetailType.sendData:
        return BSFSendDataSynchronizerErrorDetailModel.fromJson(json);
    }
  }

  static SynchronizerErrorDetailEntity _detailFromEntity(
    SynchronizerErrorDetailEntity entity,
  ) {
    if (entity is BSFCouponSynchronizerErrorDetailEntity) {
      return BSFCouponSynchronizerErrorDetailModel.fromEntity(entity);
    }
    if (entity is BSFCashierMovementSynchronizerErrorDetailEntity) {
      return BSFCashierMovementSynchronizerErrorDetailModel.fromEntity(entity);
    }
    if (entity is BSFFiscalNoteSynchronizerErrorDetailEntity) {
      return BSFFiscalNoteSynchronizerErrorDetailModel.fromEntity(entity);
    }
    if (entity is BSFNFeDisableSynchronizerErrorDetailEntity) {
      return BSFNFeDisableSynchronizerErrorDetailModel.fromEntity(entity);
    }
    if (entity is BSFScheduleSynchronizerErrorDetailEntity) {
      return BSFScheduleSynchronizerErrorDetailModel.fromEntity(entity);
    }
    if (entity is BSFTransactionSynchronizerErrorDetailEntity) {
      return BSFTransactionSynchronizerErrorDetailModel.fromEntity(entity);
    }
    if (entity is BSFTreasuryMovementSynchronizerErrorDetailEntity) {
      return BSFTreasuryMovementSynchronizerErrorDetailModel.fromEntity(entity);
    }
    if (entity is BSFMapSummarySaleEcfSynchronizerErrorDetailEntity) {
      return BSFMapSummarySaleEcfSynchronizerErrorDetailModel.fromEntity(
        entity,
      );
    }
    if (entity is BSFCustomerWithErrorSynchronizerErrorDetailEntity) {
      return BSFCustomerWithErrorSynchronizerErrorDetailModel.fromEntity(
        entity,
      );
    }
    if (entity is BSFCustomerWaitingApprovalSynchronizerErrorDetailEntity) {
      return BSFCustomerWaitingApprovalSynchronizerErrorDetailModel.fromEntity(
        entity,
      );
    }
    if (entity is BSFSaleRequestWithErrorSynchronizerErrorDetailEntity) {
      return BSFSaleRequestWithErrorSynchronizerErrorDetailModel.fromEntity(
        entity,
      );
    }
    if (entity is BSFSaleRequestWaitingApprovalSynchronizerErrorDetailEntity) {
      return BSFSaleRequestWaitingApprovalSynchronizerErrorDetailModel.fromEntity(
        entity,
      );
    }
    if (entity is BSFSaleRequestMarkedSynchronizerErrorDetailEntity) {
      return BSFSaleRequestMarkedSynchronizerErrorDetailModel.fromEntity(
        entity,
      );
    }
    if (entity is BSFProductWithErrorSynchronizerErrorDetailEntity) {
      return BSFProductWithErrorSynchronizerErrorDetailModel.fromEntity(entity);
    }
    if (entity is BSFReadBleedingSynchronizerErrorDetailEntity) {
      return BSFReadBleedingSynchronizerErrorDetailModel.fromEntity(entity);
    }
    if (entity is BSFCorrespondentBankingSynchronizerErrorDetailEntity) {
      return BSFCorrespondentBankingSynchronizerErrorDetailModel.fromEntity(
        entity,
      );
    }
    if (entity is BSFSaleMovementScanntechLoadSynchronizerErrorDetailEntity) {
      return BSFSaleMovementScanntechLoadSynchronizerErrorDetailModel.fromEntity(
        entity,
      );
    }
    if (entity is BSFSendDataSynchronizerErrorDetailEntity) {
      return BSFSendDataSynchronizerErrorDetailModel.fromEntity(entity);
    }
    throw ArgumentError.value(entity, 'entity', 'Unsupported detail entity');
  }

  static Map _detailToJson(SynchronizerErrorDetailEntity detail) {
    final model = _detailFromEntity(detail);
    if (model is BSFCouponSynchronizerErrorDetailModel) return model.toJson();
    if (model is BSFCashierMovementSynchronizerErrorDetailModel) {
      return model.toJson();
    }
    if (model is BSFFiscalNoteSynchronizerErrorDetailModel) {
      return model.toJson();
    }
    if (model is BSFNFeDisableSynchronizerErrorDetailModel) {
      return model.toJson();
    }
    if (model is BSFScheduleSynchronizerErrorDetailModel) return model.toJson();
    if (model is BSFTransactionSynchronizerErrorDetailModel) {
      return model.toJson();
    }
    if (model is BSFTreasuryMovementSynchronizerErrorDetailModel) {
      return model.toJson();
    }
    if (model is BSFMapSummarySaleEcfSynchronizerErrorDetailModel) {
      return model.toJson();
    }
    if (model is BSFCustomerWithErrorSynchronizerErrorDetailModel) {
      return model.toJson();
    }
    if (model is BSFCustomerWaitingApprovalSynchronizerErrorDetailModel) {
      return model.toJson();
    }
    if (model is BSFSaleRequestWithErrorSynchronizerErrorDetailModel) {
      return model.toJson();
    }
    if (model is BSFSaleRequestWaitingApprovalSynchronizerErrorDetailModel) {
      return model.toJson();
    }
    if (model is BSFSaleRequestMarkedSynchronizerErrorDetailModel) {
      return model.toJson();
    }
    if (model is BSFProductWithErrorSynchronizerErrorDetailModel) {
      return model.toJson();
    }
    if (model is BSFReadBleedingSynchronizerErrorDetailModel) {
      return model.toJson();
    }
    if (model is BSFCorrespondentBankingSynchronizerErrorDetailModel) {
      return model.toJson();
    }
    if (model is BSFSaleMovementScanntechLoadSynchronizerErrorDetailModel) {
      return model.toJson();
    }
    if (model is BSFSendDataSynchronizerErrorDetailModel) return model.toJson();
    throw StateError('Unsupported detail model: ${model.runtimeType}');
  }

  static SynchronizerErrorDetailEntity _detailToEntity(
    SynchronizerErrorDetailEntity detail,
  ) {
    final model = _detailFromEntity(detail);
    if (model is BSFCouponSynchronizerErrorDetailModel) return model.toEntity();
    if (model is BSFCashierMovementSynchronizerErrorDetailModel) {
      return model.toEntity();
    }
    if (model is BSFFiscalNoteSynchronizerErrorDetailModel) {
      return model.toEntity();
    }
    if (model is BSFNFeDisableSynchronizerErrorDetailModel) {
      return model.toEntity();
    }
    if (model is BSFScheduleSynchronizerErrorDetailModel) {
      return model.toEntity();
    }
    if (model is BSFTransactionSynchronizerErrorDetailModel) {
      return model.toEntity();
    }
    if (model is BSFTreasuryMovementSynchronizerErrorDetailModel) {
      return model.toEntity();
    }
    if (model is BSFMapSummarySaleEcfSynchronizerErrorDetailModel) {
      return model.toEntity();
    }
    if (model is BSFCustomerWithErrorSynchronizerErrorDetailModel) {
      return model.toEntity();
    }
    if (model is BSFCustomerWaitingApprovalSynchronizerErrorDetailModel) {
      return model.toEntity();
    }
    if (model is BSFSaleRequestWithErrorSynchronizerErrorDetailModel) {
      return model.toEntity();
    }
    if (model is BSFSaleRequestWaitingApprovalSynchronizerErrorDetailModel) {
      return model.toEntity();
    }
    if (model is BSFSaleRequestMarkedSynchronizerErrorDetailModel) {
      return model.toEntity();
    }
    if (model is BSFProductWithErrorSynchronizerErrorDetailModel) {
      return model.toEntity();
    }
    if (model is BSFReadBleedingSynchronizerErrorDetailModel) {
      return model.toEntity();
    }
    if (model is BSFCorrespondentBankingSynchronizerErrorDetailModel) {
      return model.toEntity();
    }
    if (model is BSFSaleMovementScanntechLoadSynchronizerErrorDetailModel) {
      return model.toEntity();
    }
    if (model is BSFSendDataSynchronizerErrorDetailModel) {
      return model.toEntity();
    }
    throw StateError('Unsupported detail model: ${model.runtimeType}');
  }
}
