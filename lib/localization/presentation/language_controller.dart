import 'dart:async';

import 'package:celta_inventario/localization/domain/domain.dart';
import 'package:celta_inventario/localization/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'language_controller.g.dart';

@Riverpod(keepAlive: true)
class LanguageController extends _$LanguageController {
  Future<void> _pendingSave = Future.value();
  AppLanguage _language = AppLanguage.defaultLanguage;

  AppLanguage get language => _language;

  @override
  FutureOr<AppLanguage> build() {
    _language = ref.watch(languageRepositoryProvider).loadLanguage();
    return _language;
  }

  Future<void> setLanguage(AppLanguage language) {
    // Serialize writes so rapid selections retain the last requested language.
    _pendingSave = _pendingSave.then((_) async {
      if (!ref.mounted) return;
      final result = await AsyncValue.guard(() async {
        await ref.read(languageRepositoryProvider).saveLanguage(language);
        return language;
      });
      if (!ref.mounted) return;
      if (result.hasValue) _language = result.requireValue;
      state = result;
    });
    return _pendingSave;
  }
}
