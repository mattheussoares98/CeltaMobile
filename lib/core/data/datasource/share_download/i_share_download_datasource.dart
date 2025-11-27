import 'dart:typed_data';

import 'package:equatable/equatable.dart';

abstract class IShareDownloadDatasource {
  Future<void> share(List<FileProperties> files);
  Future<void> download(FileProperties file, bool isWeb);
}

class FileProperties extends Equatable {
  final String name;
  final Uint8List bytes;
  final String? mimeType; // need use when is a xlsx file

  const FileProperties({
    required this.name,
    required this.bytes,
    this.mimeType,
  });

  @override
  List<Object?> get props => [name, bytes, mimeType];
}
