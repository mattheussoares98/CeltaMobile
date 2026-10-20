import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:celta_inventario/localization/providers.dart';

import 'package:celta_inventario/core/data/datasource/share_download/share_download.dart';

part 'share_download.g.dart';

@riverpod
IShareDownloadDatasource shareDownloadDatasource(Ref ref) {
  return ShareDownloadDatasource(
    translations: ref.watch(appLocalizationsProvider),
  );
}
