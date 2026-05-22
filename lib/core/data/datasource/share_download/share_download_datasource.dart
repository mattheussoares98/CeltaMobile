import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:share_plus/share_plus.dart';

import 'package:celta_inventario/exceptions/exceptions.dart';
import 'package:celta_inventario/core/data/datasource/share_download/share_download.dart';

class ShareDownloadDatasource implements IShareDownloadDatasource {
  @override
  Future<String?> download(FileProperties file, TargetPlatform platform) async {
    if (platform != TargetPlatform.windows &&
        platform != TargetPlatform.macOS &&
        kIsWeb) {
      throw AppException(
        'Não deveria cair nesse trecho do código. Acione o suporte técnico'
            .hardcoded,
      );
    }

    final response = await FilePicker.platform.saveFile(
      bytes: file.bytes,
      fileName: '${file.name}${file.extension}',
    );

    if (response == null && !kIsWeb) {
      throw AppException(
        'Você precisa selecionar uma pasta para salvar o arquivo'.hardcoded,
      );
    }

    return response;
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
        text: "Aqui estão os dados gerados pelo CeltaMobile...".hardcoded,
        fileNameOverrides: [fullName],
      ),
    );
    debugPrint(result.toString());
  }
}
