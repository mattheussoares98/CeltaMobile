import 'package:celta_inventario/features/print_label_layout/domain/entities/entities.dart';
import 'package:celta_inventario/features/print_label_layout/presentation/pages/components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../mocks/mocks.dart';

void main() {
  testWidgets('should show the formatted preview value from the API', (
    tester,
  ) async {
    final field = EntityFactory.makeBSFPrintLabelLayoutFieldEntity();

    await tester.pumpWidget(
      MaterialApp(
        home: PrintLabelPreviewElement(
          field: field,
          coordinateUnit: BSFPrintLabelCoordinateUnit.centimeter,
          scaleX: 1,
          scaleY: 1,
          isOutsideLabel: false,
        ),
      ),
    );

    expect(find.text(field.previewValue!), findsOneWidget);
    expect(find.text('${field.prefix}${field.field!.content}'), findsNothing);
  });
}
