import '../models/models.dart';

abstract class ISoapInsertTransferRequestDatasource {
  Future<String> save({
    required String urlInUse,
    required String crossIdentity,
    required int enterpriseOriginCode,
    required int enterpriseDestinyCode,
    required int requestTypeCode,
    required List<TransferRequestProductItemModel> products,
  });
}
