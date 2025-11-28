import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/datasource/share_download/share_download.dart';
import '../../../providers/share_download/share_download.dart';

part 'share_download_controller.g.dart';

@riverpod
class ShareDownloadController extends _$ShareDownloadController {
  @override
  FutureOr<void> build() async {}

  Future<void> share(FileProperties file) async {
    await ref.read(shareDownloadDatasourceProvider).share(file);
  }

  Future<String?> download(FileProperties file, TargetPlatform platform) async {
    return await ref
        .read(shareDownloadDatasourceProvider)
        .download(file, platform);
  }
}
