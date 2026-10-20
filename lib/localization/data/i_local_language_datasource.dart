abstract interface class ILocalLanguageDatasource {
  String? loadLanguageCode();
  Future<void> saveLanguageCode(String code);
}
