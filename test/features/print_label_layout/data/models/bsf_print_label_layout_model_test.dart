import 'package:celta_inventario/features/print_label_layout/data/models/models.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../mocks/mocks.dart';

void main() {
  test('should serialize the complete replaced field collection', () {
    final replacedField = EntityFactory.makeBSFPrintLabelLayoutFieldEntity(
      code: 0,
      field: EntityFactory.makeBSFPrintLabelFieldDefinitionEntity(code: 22),
    ).copyWith(prefix: 'Oferta: ');
    final layout = EntityFactory.makeBSFPrintLabelLayoutEntity(
      fields: [replacedField],
    );

    final json = BSFPrintLabelLayoutModel.fromEntity(layout).toJson();
    final fields = json['fields'] as List;
    final field = fields.single as Map;

    expect(fields, hasLength(1));
    expect(field['code'], 0);
    expect(field['prefix'], 'Oferta: ');
    expect((field['field'] as Map)['code'], 22);
  });
}
