import 'dart:convert';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';

import '../../domain/entities/entities.dart';

class AttachmentsModel extends Equatable {
  final String FileExtension;
  final Uint8List AttachmentBase64;

  const AttachmentsModel({
    required this.FileExtension,
    required this.AttachmentBase64,
  });

  @override
  List<Object?> get props => [FileExtension, AttachmentBase64];

  Map toJson() => {
    'FileExtension': FileExtension,

    'AttachmentBase64': base64Encode(AttachmentBase64),
  };

  factory AttachmentsModel.fromJson(Map json) {
    return AttachmentsModel(
      FileExtension: json['FileExtension'] as String,

      AttachmentBase64: base64Decode(json['AttachmentBase64'] as String),
    );
  }

  factory AttachmentsModel.fromEntity(AttachmentsEntity entity) {
    return AttachmentsModel(
      FileExtension: entity.FileExtension,
      AttachmentBase64: entity.AttachmentBase64,
    );
  }

  AttachmentsEntity toEntity() {
    return AttachmentsEntity(
      FileExtension: FileExtension,
      AttachmentBase64: AttachmentBase64,
    );
  }
}
