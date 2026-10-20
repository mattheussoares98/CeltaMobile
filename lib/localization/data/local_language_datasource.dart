import 'package:celta_inventario/localization/data/data.dart';
import 'package:hive/hive.dart';

class LocalLanguageDatasource implements ILocalLanguageDatasource {
  const LocalLanguageDatasource(this.box);

  final Box box;
  static const languageCodeKey = 'languageCode';

  @override
  String? loadLanguageCode() => box.get(languageCodeKey) as String?;

  @override
  Future<void> saveLanguageCode(String code) async {
    await box.put(languageCodeKey, code);
    await box.flush();
  }
}
