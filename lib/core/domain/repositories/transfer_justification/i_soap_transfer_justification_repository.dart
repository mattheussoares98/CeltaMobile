import 'package:celta_inventario/core/domain/entities/entities.dart';

abstract class ISoapTransferJustificationRepository {
  Future<List<TransferJustificationEntity>> load({
    required String workingUrl,
    required String crossIdentity,
    required TransferJustificationType type,
  });
}
