import 'package:celta_inventario/core/infraestructure/infrastructure.dart';
import 'package:celta_inventario/localization/data/data.dart';
import 'package:celta_inventario/localization/domain/domain.dart';
import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers.g.dart';

@Riverpod(keepAlive: true)
ILocalLanguageDatasource localLanguageDatasource(Ref ref) =>
    LocalLanguageDatasource(Hive.box(DatabaseConstants.localization.name));

@Riverpod(keepAlive: true)
ILanguageRepository languageRepository(Ref ref) =>
    LanguageRepositoryImpl(ref.watch(localLanguageDatasourceProvider));
