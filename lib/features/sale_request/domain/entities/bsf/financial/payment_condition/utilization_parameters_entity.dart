import 'package:equatable/equatable.dart';

class UtilizationParametersEntity extends Equatable {
  final bool isShielded;
  final DateTime baseDate;
  final double valueParcel;

  const UtilizationParametersEntity({
    required this.isShielded,
    required this.baseDate,
    required this.valueParcel,
  });

  @override
  List<Object?> get props => [isShielded, baseDate, valueParcel];

  UtilizationParametersEntity copyWith({
    bool? isShielded,
    DateTime? baseDate,
    double? valueParcel,
  }) {
    return UtilizationParametersEntity(
      isShielded: isShielded ?? this.isShielded,
      baseDate: baseDate ?? this.baseDate,
      valueParcel: valueParcel ?? this.valueParcel,
    );
  }
}
