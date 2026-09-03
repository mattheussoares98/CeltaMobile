import 'package:celta_inventario/features/print_label_layout/data/models/models.dart';
import 'package:celta_inventario/features/print_label_layout/domain/entities/entities.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../mocks/mocks.dart';

void main() {
  test('should preserve preview value and image across all conversions', () {
    final entity = EntityFactory.makeBSFPrintLabelLayoutFieldEntity();
    final model = BSFPrintLabelLayoutFieldModel.fromEntity(entity);

    final json = model.toJson();
    final result = BSFPrintLabelLayoutFieldModel.fromJson(json);

    expect(json['previewImage'], isA<String>());
    expect(result, model);
    expect(result.toEntity(), entity);
  });

  test('should serialize every barcode editor value', () {
    final representativeField =
        EntityFactory.makeBSFPrintLabelFieldDefinitionEntity(code: 90);
    final entity = EntityFactory.makeBSFPrintLabelLayoutFieldEntity(
      ratioBarCode: 3,
      barcodeSimbologyType: BSFBarcodeSimbologyType.code128,
      fieldForDataBarcode: representativeField,
    );

    final json = BSFPrintLabelLayoutFieldModel.fromEntity(entity).toJson();
    final result = BSFPrintLabelLayoutFieldModel.fromJson(json);

    expect(json['ratioBarCode'], 3);
    expect(json['barcodeSimbologyType'], 'Code128');
    expect((json['fieldForDataBarcode'] as Map)['code'], 90);
    expect(result.ratioBarCode, 3);
    expect(result.barcodeSimbologyType, BSFBarcodeSimbologyType.code128);
    expect(result.fieldForDataBarcode?.code, representativeField.code);
  });
}
