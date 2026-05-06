import 'package:equatable/equatable.dart';
import 'financial.dart';

class BSFPaymentFormEntity extends Equatable {
  final PaymentFormType? type;
  final String? reducedName;
  final String? name;

  const BSFPaymentFormEntity({
    this.type,
    this.reducedName,
    this.name,
  });

  @override
  List<Object?> get props => [type, reducedName, name];
}
