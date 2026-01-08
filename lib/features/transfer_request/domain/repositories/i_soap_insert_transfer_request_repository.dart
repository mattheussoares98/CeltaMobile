import '../entities/entities.dart';

abstract class ISoapInsertTransferRequestRepository {
  Future<String> save({
    required String workingUrl,
    required String crossIdentity,
    required int enterpriseOriginCode,
    required int enterpriseDestinyCode,
    required int requestTypeCode,
    required List<TransferRequestProductItemEntity> products,
  });
}
