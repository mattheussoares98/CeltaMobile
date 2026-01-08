abstract class ISoapUrlValidationRepository {
  Future<String?> findWorkingUrl(List<String> urls);
}
