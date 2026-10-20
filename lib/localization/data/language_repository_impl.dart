import 'package:celta_inventario/localization/data/data.dart';
import 'package:celta_inventario/localization/domain/domain.dart';

class LanguageRepositoryImpl implements ILanguageRepository {
  const LanguageRepositoryImpl(this.datasource);

  final ILocalLanguageDatasource datasource;

  @override
  AppLanguage loadLanguage() =>
      AppLanguage.fromCode(datasource.loadLanguageCode());

  @override
  Future<void> saveLanguage(AppLanguage language) =>
      datasource.saveLanguageCode(language.code);
}
