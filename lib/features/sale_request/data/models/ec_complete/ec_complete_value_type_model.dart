import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/entities.dart';

class EcCompleteValueTypeModel extends Equatable {
  final PercentageOrValue? type;
  final double? value;

  const EcCompleteValueTypeModel({required this.type, required this.value});

  factory EcCompleteValueTypeModel.fromJson(Map<String, dynamic> json) =>
      EcCompleteValueTypeModel(
        type: PercentageOrValue.values.firstWhereOrNull(
          (e) => e.code == json['Type'],
        ),
        value: (json['Value'] as num?)?.toDouble(),
      );

  Map<String, dynamic> toJson() => {'Type': type?.code, 'Value': value};

  @override
  List<Object?> get props => [type, value];
}
