import 'package:celta_inventario/core/domain/entities/transfer_justification/transfer_justification_entity.dart';

import 'package:celta_inventario/core/domain/entities/transfer_justification/transfer_justification_type.dart';

import 'package:celta_inventario/core/data/datasource/transfer_justification/transfer_justification.dart';
import 'package:celta_inventario/core/domain/repositories/transfer_justification/transfer_justification.dart';

class SoapTransferJustificationRepositoryImpl
    implements ISoapTransferJustificationRepository {
  final ISoapTransferJustificationDatasource datasource;

  SoapTransferJustificationRepositoryImpl(this.datasource);

  @override
  Future<List<TransferJustificationEntity>> load({
    required String workingUrl,
    required String crossIdentity,
    required TransferJustificationType type,
  }) async {
    final justifications = await datasource.load(
      workingUrl: workingUrl,
      crossIdentity: crossIdentity,
      type: type,
    );

    return justifications.map((e) => e.toEntity()).toList();
  }
}
