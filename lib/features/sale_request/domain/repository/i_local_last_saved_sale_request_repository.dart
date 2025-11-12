import '../entities/entities.dart';

abstract class ILocalLastSavedSaleRequestRepository {
  Future<void> save({
    required LastSavedSaleRequestEntity value,
    required int enterpriseCode,
  });
  Future<LastSavedSaleRequestEntity?> load(int enterpriseCode);
}
