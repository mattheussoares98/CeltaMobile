import 'package:celta_intelligence/core/domain/entities/transfer_justification/transfer_justification_entity.dart';

import 'package:celta_intelligence/core/domain/entities/transfer_justification/transfer_justification_type.dart';

import '../../../data/datasource/transfer_justification/transfer_justification.dart';
import 'transfer_justification.dart';

class SoapTransferJustificationRepositoryImpl
    implements ISoapTransferJustificationRepository {
  final ISoapTransferJustificationDatasource datasource;

  SoapTransferJustificationRepositoryImpl(this.datasource);

  @override
  Future<List<TransferJustificationEntity>> load({
    required String baseUrl,
    required String crossIdentity,
    required TransferJustificationType type,
  }) async {
    final justifications = await datasource.load(
      baseUrl: baseUrl,
      crossIdentity: crossIdentity,
      type: type,
    );

    return justifications.map((e) => e.toEntity()).toList();
  }
}
