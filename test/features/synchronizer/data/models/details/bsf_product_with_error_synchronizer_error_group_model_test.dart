import 'package:celta_inventario/features/synchronizer/data/models/models.dart';
import 'package:celta_inventario/features/synchronizer/domain/entities/entities.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../mocks/mocks.dart';

void main() {
  test('should preserve the grouped product errors across all conversions', () {
    final entity =
        EntityFactory.makeEcProductWithErrorSynchronizerErrorGroupEntity(
          type: EcProductWithErrorType.markedToSendAgain,
        );
    final model = EcProductWithErrorSynchronizerErrorGroupModel.fromEntity(
      entity,
    );

    final json = model.toJson();
    final result = EcProductWithErrorSynchronizerErrorGroupModel.fromJson(json);

    expect(json['Type'], EcProductWithErrorType.markedToSendAgain.value);
    expect(result, model);
    expect(result.toEntity(), entity);
  });

  test('should reject an unsupported product-with-error type', () {
    expect(
      () => EcProductWithErrorType.fromValue(4),
      throwsA(isA<FormatException>()),
    );
  });

  test('should parse product-with-error items as groups', () {
    final group =
        EntityFactory.makeEcProductWithErrorSynchronizerErrorGroupEntity();
    final entity = EntityFactory.makeSynchronizerErrorDetailsEntity(
      detailType: SynchronizerErrorDetailType.productWithError,
      items: [group],
    );
    final model = EcSynchronizerErrorDetailsModel.fromEntity(entity);

    final result = EcSynchronizerErrorDetailsModel.fromJson(model.toJson());

    expect(
      result.items.single,
      isA<EcProductWithErrorSynchronizerErrorGroupModel>(),
    );
    expect(result.toEntity(), entity);
  });
}
