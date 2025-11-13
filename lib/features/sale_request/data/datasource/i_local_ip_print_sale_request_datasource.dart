abstract class ILocalIpPrintSaleRequestDatasource {
  Future<String?> load();
  Future<void> save(String ip);
}
