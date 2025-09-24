import '../../../domain/entities/transfer_justification/transfer_justification.dart';
import '../../models/models.dart';

abstract class ISoapLoadJustificationsDatasource {
  Future<List<TransferJustificationModel>> load({
    required String baseUrl,
    required String crossIdentity,
    required TransferJustificationType type,
  });
}
