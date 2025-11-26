import 'dart:typed_data';

import 'package:equatable/equatable.dart';

class AttachmentsEntity extends Equatable {
  final String FileExtension;
  final Uint8List AttachmentBase64;

  const AttachmentsEntity({
    required this.FileExtension,
    required this.AttachmentBase64,
  });

  @override
  List<Object?> get props => [FileExtension, AttachmentBase64];
}
