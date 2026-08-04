import 'package:celta_inventario/features/synchronizer/data/models/models.dart';
import 'package:celta_inventario/features/synchronizer/domain/entities/entities.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../mocks/mocks.dart';

void main() {
  test('should preserve the grouped product errors across all conversions', () {
    final entity =
        EntityFactory.makeBSFProductWithErrorSynchronizerErrorGroupEntity(
          type: BSFProductWithErrorType.markedToSendAgain,
        );
    final model = BSFProductWithErrorSynchronizerErrorGroupModel.fromEntity(
      entity,
    );

    final json = model.toJson();
    final result = BSFProductWithErrorSynchronizerErrorGroupModel.fromJson(
      json,
    );

    expect(json['Type'], BSFProductWithErrorType.markedToSendAgain.value);
    expect(result, model);
    expect(result.toEntity(), entity);
  });

  test('should reject an unsupported product-with-error type', () {
    expect(
      () => BSFProductWithErrorType.fromValue(4),
      throwsA(isA<FormatException>()),
    );
  });

  test('should parse product-with-error items as groups', () {
    final group =
        EntityFactory.makeBSFProductWithErrorSynchronizerErrorGroupEntity();
    final entity = EntityFactory.makeSynchronizerErrorDetailsEntity(
      detailType: SynchronizerErrorDetailType.productWithError,
      items: [group],
    );
    final model = SynchronizerErrorDetailsModel.fromEntity(entity);

    final result = SynchronizerErrorDetailsModel.fromJson(model.toJson());

    expect(
      result.items.single,
      isA<BSFProductWithErrorSynchronizerErrorGroupModel>(),
    );
    expect(result.toEntity(), entity);
  });
}
