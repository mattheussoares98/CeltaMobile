import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/datasource/share_download/share_download.dart';
import '../../../providers/share_download/share_download.dart';

part 'share_download_controller.g.dart';

@riverpod
class ShareDownloadController extends _$ShareDownloadController {
  @override
  FutureOr<void> build() async {}

  Future<void> shareOrDownload(
    FileProperties file,
    TargetPlatform platform,
  ) async {
    if (platform == TargetPlatform.android || platform == TargetPlatform.iOS) {
      await ref.read(shareDownloadDatasourceProvider).share(file);
    } else {
      await ref.read(shareDownloadDatasourceProvider).download(file, kIsWeb);
    }
  }
}
