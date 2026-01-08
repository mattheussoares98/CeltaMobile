import '../../../domain/entities/transfer_justification/transfer_justification.dart';
import '../../models/models.dart';

abstract class ISoapTransferJustificationDatasource {
  Future<List<TransferJustificationModel>> load({
    required String urlInUse,
    required String crossIdentity,
    required TransferJustificationType type,
  });
}
