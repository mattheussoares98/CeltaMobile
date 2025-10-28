abstract class ILocalLastSavedNumberRepository {
  Future<String?> load();
  Future<void> save(String number);
}
