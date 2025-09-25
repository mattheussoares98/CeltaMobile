import '../../entities/entities.dart';

abstract class ISoapTransferJustificationRepository {
  Future<List<TransferJustificationEntity>> load({
    required String baseUrl,
    required String crossIdentity,
    required TransferJustificationType type,
  });
}
