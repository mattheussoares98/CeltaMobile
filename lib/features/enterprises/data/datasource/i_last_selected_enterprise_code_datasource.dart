abstract class ILastSelectedEnterpriseCodeDatasource {
  Future<int?> load();
  Future<void> update(int code);
}
