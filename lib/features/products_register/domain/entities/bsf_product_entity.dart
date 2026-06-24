import 'package:celta_inventario/features/products_register/domain/entities/entities.dart';

class BsfProductEntity {
  final int code;
  final String name;
  final bool isDesativate;

  const BsfProductEntity({
    required this.code,
    required this.name,
    required this.isDesativate,
  });

  BsfProductEntity copyWith({int? code, String? name, bool? isDesativate}) {
    return BsfProductEntity(
      code: code ?? this.code,
      name: name ?? this.name,
      isDesativate: isDesativate ?? this.isDesativate,
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
    ];
  }
}
