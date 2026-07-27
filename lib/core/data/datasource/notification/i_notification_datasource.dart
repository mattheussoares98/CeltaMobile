abstract class INotificationDatasource {
  Future<String?> getToken();
  Stream<String> get onTokenRefresh;
}
