abstract class ILocalLastSavedNumberDatasource {
  Future<String?> load();
  Future<void> save(String number);
}
