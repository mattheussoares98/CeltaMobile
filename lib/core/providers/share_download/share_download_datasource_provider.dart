import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/datasource/share_download/share_download.dart';

part 'share_download_datasource_provider.g.dart';

@riverpod
IShareDownloadDatasource shareDownloadDatasource(Ref ref) {
  return ShareDownloadDatasource();
}
