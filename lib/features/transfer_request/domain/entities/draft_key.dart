import 'package:equatable/equatable.dart';

class DraftKey extends Equatable {
  final int requestTypeCode;
  final int enterpriseOrigin;
  final int enterpriseDestinyCode;

  const DraftKey({
    required this.requestTypeCode,
    required this.enterpriseOrigin,
    required this.enterpriseDestinyCode,
  });

  @override
  List<Object?> get props => [
    requestTypeCode,
    enterpriseOrigin,
    enterpriseDestinyCode,
  ];

  String toMapKey() {
    return '$requestTypeCode-$enterpriseOrigin-$enterpriseDestinyCode';
  }

  factory DraftKey.fromMapKey(String key) {
    final parts = key.split('-');
    if (parts.length != 3) {
      throw const FormatException('Invalid ProductKey format');
    }
    return DraftKey(
      requestTypeCode: int.parse(parts[0]),
      enterpriseOrigin: int.parse(parts[1]),
      enterpriseDestinyCode: int.parse(parts[2]),
    );
  }
}
