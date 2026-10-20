enum AppLanguage {
  portuguese('pt'),
  english('en');

  const AppLanguage(this.code);

  final String code;

  static const defaultLanguage = portuguese;

  static AppLanguage fromCode(String? code) => values.firstWhere(
    (language) => language.code == code,
    orElse: () => defaultLanguage,
  );
}
