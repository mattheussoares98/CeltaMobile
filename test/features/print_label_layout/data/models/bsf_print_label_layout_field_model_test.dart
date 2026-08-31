import 'package:celta_inventario/features/print_label_layout/data/models/models.dart';
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
}
