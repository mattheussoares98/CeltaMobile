import 'package:celta_inventario/core/domain/errors/errors.dart';
import 'package:celta_inventario/core/data/datasource/share_download/share_download.dart';
import 'package:celta_inventario/exceptions/exceptions.dart';
import 'package:celta_inventario/localization/localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:share_plus/share_plus.dart';

class ShareDownloadDatasource implements IShareDownloadDatasource {
  ShareDownloadDatasource({AppLocalizations? translations})
    : translations = translations ?? defaultLocalizations;

  final AppLocalizations translations;

  @override
  Future<String?> download(FileProperties file, TargetPlatform platform) async {
    if (platform != TargetPlatform.windows &&
        platform != TargetPlatform.macOS &&
        kIsWeb) {
      throw AppException.localized(CoreFailure.unsupportedDownload);
    }

    final response = await FilePicker.saveFile(
      bytes: file.bytes,
      fileName: '${file.name}${file.extension}',
    );

    if (response == null && !kIsWeb) {
      throw AppException.localized(CoreFailure.selectSaveFolder);
    }

    return response?.path;
  }

  @override
  Future<void> share(FileProperties file) async {
    final String fullName = '${file.name}${file.extension ?? ''}';

    final result = await SharePlus.instance.share(
      ShareParams(
        files: file.filePath != null
            ? [XFile(file.filePath!)]
            : [
                XFile.fromData(
                  file.bytes,
                  name: fullName,
                  mimeType: file.mimeType,
                ),
              ],
        text: translations.sharedData,
        fileNameOverrides: [fullName],
      ),
    );
    debugPrint(result.toString());
  }
}
