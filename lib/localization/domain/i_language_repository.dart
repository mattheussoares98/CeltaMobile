import 'package:celta_inventario/localization/domain/domain.dart';

abstract interface class ILanguageRepository {
  AppLanguage loadLanguage();
  Future<void> saveLanguage(AppLanguage language);
}
