import 'package:celta_inventario/features/synchronizer/data/models/models.dart';
import 'package:celta_inventario/features/synchronizer/domain/entities/entities.dart';

class SynchronizerErrorDetailsModel extends SynchronizerErrorDetailsEntity {
  const SynchronizerErrorDetailsModel({
    required super.category,
    required super.errorKey,
    required super.items,
  });

  factory SynchronizerErrorDetailsModel.fromJson(Map json) {
    final errorKey = json['ErrorKey'] as String;
    return SynchronizerErrorDetailsModel(
      category: json['Category'] as String,
      errorKey: errorKey,
      items: (json['Items'] as List)
          .map((item) => _detailFromJson(errorKey, item as Map))
          .toList(),
    );
  }

  Map toJson() => {
    'Category': category,
    'ErrorKey': errorKey,
    'Items': items.map(_detailToJson).toList(),
  };

  factory SynchronizerErrorDetailsModel.fromEntity(
    SynchronizerErrorDetailsEntity entity,
  ) => SynchronizerErrorDetailsModel(
    category: entity.category,
    errorKey: entity.errorKey,
    items: entity.items.map(_detailFromEntity).toList(),
  );

  SynchronizerErrorDetailsEntity toEntity() => SynchronizerErrorDetailsEntity(
    category: category,
    errorKey: errorKey,
    items: items.map(_detailToEntity).toList(),
  );

  static SynchronizerErrorDetailEntity _detailFromJson(
    String errorKey,
    Map json,
  ) {
    switch (errorKey) {
      case 'Cupons não lidos (erros durante a leitura de vendas)':
      case 'Cupons não lidos (marcados para releitura)':
        return BSFCouponSynchronizerErrorDetailModel.fromJson(json);
      case 'Movimentos de caixa não lidos (erros durante a leitura de vendas)':
      case 'Movimentos de caixa não lidos (marcados para releitura)':
        return BSFCashierMovementSynchronizerErrorDetailModel.fromJson(json);
      case 'Notas fiscais baseadas em cupom (não vinculadas à venda alguma)':
        return BSFFiscalNoteSynchronizerErrorDetailModel.fromJson(json);
      case 'Notas fiscais (NFCe) a serem inutilizadas (não vinculadas à venda alguma)':
        return BSFNFeDisableSynchronizerErrorDetailModel.fromJson(json);
      case 'Problemas na execução das tarefas do sincronizador':
        return BSFScheduleSynchronizerErrorDetailModel.fromJson(json);
      case 'Transações com erro':
        return BSFTransactionSynchronizerErrorDetailModel.fromJson(json);
      case 'Vendas lidas após o fechamento de caixa (o caixa foi fechado antes que a venda fosse gravada)':
        return BSFTreasuryMovementSynchronizerErrorDetailModel.fromJson(json);
      case 'Mapas resumo de caixas não lidos (erros durante a leitura de vendas)':
      case 'Mapas resumo de caixas não lidos (marcados para releitura)':
        return BSFMapSummarySaleEcfSynchronizerErrorDetailModel.fromJson(json);
      case 'Clientes com erros (erros durante a leitura de pedidos)':
        return BSFCustomerWithErrorSynchronizerErrorDetailModel.fromJson(json);
      case 'Clientes aguardando aprovação':
        return BSFCustomerWaitingApprovalSynchronizerErrorDetailModel.fromJson(
          json,
        );
      case 'Pedidos de vendas com erros (erros durante a leitura de pedidos)':
      case 'Pedidos de vendas com erros durante a leitura (marcados para releitura)':
        return BSFSaleRequestWithErrorSynchronizerErrorDetailModel.fromJson(
          json,
        );
      case 'Pedidos de venda aguardando aprovação':
        return BSFSaleRequestWaitingApprovalSynchronizerErrorDetailModel.fromJson(
          json,
        );
      case 'Pedidos de venda marcados para utilização':
        return BSFSaleRequestMarkedSynchronizerErrorDetailModel.fromJson(json);
      case 'Produtos de site com problemas':
        return BSFProductWithErrorSynchronizerErrorDetailModel.fromJson(json);
      case 'Sangrias não lidas (erros durante a leitura de sangrias)':
      case 'Sangrias não lidas (marcadas para releitura)':
        return BSFReadBleedingSynchronizerErrorDetailModel.fromJson(json);
      case 'Correspondente bancário não lidos (erros durante a leitura de correspondentes bancários)':
      case 'Correspondente bancário não lidos (marcados para releitura)':
        return BSFCorrespondentBankingSynchronizerErrorDetailModel.fromJson(
          json,
        );
      case 'Problema na carga de vendas (Scanntech)':
        return BSFSaleMovementScanntechLoadSynchronizerErrorDetailModel.fromJson(
          json,
        );
      case 'Erro no envio de vendas':
      case 'Erro no envio de vendas (Marcados para reenvio)':
      case 'Erro no envio de clientes':
      case 'Erro no envio de clientes (Marcados para reenvio)':
      case 'Erro no envio de funcionários':
      case 'Erro no envio de funcionários (Marcados para reenvio)':
        return BSFSendDataSynchronizerErrorDetailModel.fromJson(json);
      default:
        throw FormatException('Unsupported synchronizer error key: $errorKey');
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
