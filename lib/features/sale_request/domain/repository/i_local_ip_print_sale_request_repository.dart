abstract class ILocalIpPrintSaleRequestRepository {
  Future<String?> load();
  Future<void> save(String ip);
}
