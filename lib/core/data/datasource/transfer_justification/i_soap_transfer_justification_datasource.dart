import 'package:celta_inventario/core/domain/entities/transfer_justification/transfer_justification.dart';
import 'package:celta_inventario/core/data/models/models.dart';

abstract class ISoapTransferJustificationDatasource {
  Future<List<TransferJustificationModel>> load({
    required String workingUrl,
    required String crossIdentity,
    required TransferJustificationType type,
  });
}
