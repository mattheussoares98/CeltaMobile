import 'dart:io';

import 'package:celta_inventario/localization/data/data.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

void main() {
  late Directory directory;
  late Box box;
  late LocalLanguageDatasource datasource;

  setUp(() async {
    directory = await Directory.systemTemp.createTemp('localization_test');
    Hive.init(directory.path);
    box = await Hive.openBox('localization');
    datasource = LocalLanguageDatasource(box);
  });

  tearDown(() async {
    await Hive.close();
    await directory.delete(recursive: true);
  });

  test('loadLanguageCode returns null for a fresh install', () {
    expect(datasource.loadLanguageCode(), isNull);
  });

  test(
    'saveLanguageCode persists across reopening and preserves other keys',
    () async {
      await box.put('unrelated', 'preserved');
      await datasource.saveLanguageCode('en');
      await box.close();
      box = await Hive.openBox('localization');
      datasource = LocalLanguageDatasource(box);
      expect(datasource.loadLanguageCode(), 'en');
      expect(box.get('unrelated'), 'preserved');
    },
  );

  test(
    'loadLanguageCode rejects malformed stored values without replacing them',
    () async {
      await box.put(LocalLanguageDatasource.languageCodeKey, 1);
      expect(datasource.loadLanguageCode, throwsA(isA<TypeError>()));
      expect(box.get(LocalLanguageDatasource.languageCodeKey), 1);
    },
  );

  test('saveLanguageCode propagates a closed box failure', () async {
    await box.close();
    await expectLater(
      datasource.saveLanguageCode('en'),
      throwsA(isA<HiveError>()),
    );
  });
}
