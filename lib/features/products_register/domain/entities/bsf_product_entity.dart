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

  List<BsfProductPropertyEntity> toSearchIndex({
    String codeLabel = 'Código',
    String nameLabel = 'Nome',
    String deactivatedLabel = 'Desativado',
    String fiscalClassificationLabel = 'Classificacao fiscal',
    String yesLabel = 'Sim',
    String noLabel = 'Não',
  }) {
    return [
      BsfProductPropertyEntity(labelPt: codeLabel, displayValue: '$code'),
      BsfProductPropertyEntity(labelPt: nameLabel, displayValue: name),
      BsfProductPropertyEntity(
        labelPt: deactivatedLabel,
        displayValue: isDesativate ? yesLabel : noLabel,
      ),
      BsfProductPropertyEntity(
        labelPt: fiscalClassificationLabel,
        displayValue: fiscalClassification.personalizedCode,
      ),
    ];
  }

  @override
  List<Object?> get props => [code, name, isDesativate, fiscalClassification];
}
