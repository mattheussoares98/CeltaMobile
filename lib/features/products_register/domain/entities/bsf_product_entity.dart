import 'package:celta_inventario/features/products_register/domain/entities/entities.dart';
import 'package:equatable/equatable.dart';

class BsfProductEntity extends Equatable {
  final int code;
  final String name;
  final bool isDesativate;
  final BsfFiscalClassificationEntity fiscalClassification;

  const BsfProductEntity({
    required this.code,
    required this.name,
    required this.isDesativate,
    required this.fiscalClassification,
  });

  BsfProductEntity copyWith({
    int? code,
    String? name,
    bool? isDesativate,
    BsfFiscalClassificationEntity? fiscalClassification,
  }) {
    return BsfProductEntity(
      code: code ?? this.code,
      name: name ?? this.name,
      isDesativate: isDesativate ?? this.isDesativate,
      fiscalClassification: fiscalClassification ?? this.fiscalClassification,
    );
  }

  List<BsfProductPropertyEntity> toSearchIndex() {
    return [
      BsfProductPropertyEntity(labelPt: 'Código', displayValue: '$code'),
      BsfProductPropertyEntity(labelPt: 'Nome', displayValue: name),
      BsfProductPropertyEntity(
        labelPt: 'Desativado',
        displayValue: isDesativate ? 'Sim' : 'Não',
      ),
      BsfProductPropertyEntity(
        labelPt: 'Classificacao fiscal',
        displayValue: fiscalClassification.personalizedCode,
      ),
    ];
  }

  @override
  List<Object?> get props => [code, name, isDesativate, fiscalClassification];
}
