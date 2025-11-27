import 'dart:io';

import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import 'share_download.dart';

class ShareDownloadDatasource implements IShareDownloadDatasource {
  @override
  Future<void> download(FileProperties file, bool isWeb) async {
    //TODO test if works in web platform

    final tempDir = await getTemporaryDirectory();

    await File('${tempDir.path}/${file.name}').writeAsBytes(file.bytes);
  }

  @override
  Future<void> share(FileProperties file) async {
    await SharePlus.instance.share(
      ShareParams(
        files: [XFile.fromData(file.bytes, name: file.name)],
        text: "Aqui estão os dados gerados pelo CeltaMobile...".hardcoded,
        fileNameOverrides: [file.name],
      ),
    );
  }
}
