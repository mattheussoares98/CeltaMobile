import 'package:equatable/equatable.dart';

class BsfFiscalClassificationIpiEntity extends Equatable {
  final double aliquot;
  final int type;
  final String tributarySituation;
  final bool isValid;

  const BsfFiscalClassificationIpiEntity({
    required this.aliquot,
    required this.type,
    required this.tributarySituation,
    required this.isValid,
  });

  @override
  List<Object?> get props => [aliquot, type, tributarySituation, isValid];
}
