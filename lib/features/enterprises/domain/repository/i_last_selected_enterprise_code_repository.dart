abstract class ILastSelectedEnterpriseCodeRepository {
  Future<int?> load();
  Future<void> update(int code);
}
