import 'dart:typed_data';

import 'package:equatable/equatable.dart';

abstract class IShareDownloadDatasource {
  Future<void> share(FileProperties files);
  Future<String?> download(FileProperties file, bool isWeb);
}

class FileProperties extends Equatable {
  final String name;
  final Uint8List bytes;
  final String? mimeType; // need use when is a xlsx file
  final String? extension;

  const FileProperties({
    required this.name,
    required this.bytes,
    required this.extension,
    this.mimeType,
  });

  @override
  List<Object?> get props => [name, bytes, mimeType, extension];
}
