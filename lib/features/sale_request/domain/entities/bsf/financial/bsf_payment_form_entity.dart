import 'package:equatable/equatable.dart';

class BSFPaymentFormEntity extends Equatable {
  final int? type;
  final String? reducedName;
  final String? name;

  const BSFPaymentFormEntity({
    required this.type,
    required this.reducedName,
    required this.name,
  });

  @override
  List<Object?> get props => [type, name];
}
