import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/providers/ec_request_params/ec_request_params.dart';
import 'package:celta_inventario/features/print_label_layout/domain/entities/entities.dart';
import 'package:celta_inventario/features/print_label_layout/domain/repositories/repositories.dart';
import 'package:celta_inventario/features/print_label_layout/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/print_label_layout/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

class MockEcPrintLabelLayoutRepository extends Mock
    implements IEcPrintLabelLayoutRepository {}

void main() {
  const layoutCode = 10;
  late MockEcPrintLabelLayoutRepository repository;
  late EcRequestParams params;
  late BSFPrintLabelLayoutEntity layout;
  late ProviderContainer container;

  setUp(() async {
    repository = MockEcPrintLabelLayoutRepository();
    params = EntityFactory.makeEcRequestParams();
    layout = EntityFactory.makeBSFPrintLabelLayoutEntity(
      code: layoutCode,
      fields: const [],
    );
    when(
      () => repository.getDetails(params, layoutCode),
    ).thenAnswer((_) async => layout);
    container = ProviderContainer(
      retry: (retryCount, error) => null,
      overrides: [
        ecRequestParamsProvider().overrideWith((ref) => params),
        ecPrintLabelLayoutRepositoryProvider.overrideWithValue(repository),
      ],
    );
    addTearDown(container.dispose);
    await container.read(
      printLabelLayoutDetailsControllerProvider(layoutCode).future,
    );
  });

  test('selectFieldOption should initialize the add-field draft', () {
    final definition = EntityFactory.makeBSFPrintLabelFieldDefinitionEntity(
      fieldType: BSFPrintLabelFieldType.float,
    );
    final draft = EntityFactory.makeBSFPrintLabelLayoutFieldEntity(
      code: 0,
      field: definition,
      width: 0,
      height: 0,
      quantityDecimalPlaces: 0,
    );
    final option = EntityFactory.makePrintLabelFieldEditorOptionEntity(
      definition: definition,
      draft: draft,
    );
    final provider = printLabelLayoutAddFieldControllerProvider(layoutCode);

    container.read(provider.notifier).selectFieldOption(option);

    final state = container.read(provider);
    expect(state.selectedOption, option);
    expect(state.draft?.alignmentType, BSFPrintElementAlignmentType.middle);
    expect(state.draft?.quantityDecimalPlaces, 2);
    expect(state.draft!.width, greaterThanOrEqualTo(draft.minimumEditorWidth));
    expect(
      state.draft!.height,
      greaterThanOrEqualTo(draft.minimumEditorHeight),
    );
  });

  test('updateField should replace the current draft', () {
    final field = EntityFactory.makeBSFPrintLabelLayoutFieldEntity(code: 0);
    final provider = printLabelLayoutAddFieldControllerProvider(layoutCode);

    container.read(provider.notifier).updateField(field);

    expect(container.read(provider).draft, field);
  });

  test('addField should do nothing without a draft', () {
    final provider = printLabelLayoutAddFieldControllerProvider(layoutCode);

    container.read(provider.notifier).addField();

    expect(
      container
          .read(printLabelLayoutDetailsControllerProvider(layoutCode))
          .requireValue
          .fields,
      isEmpty,
    );
  });

  test('addField should append the current draft to the layout', () {
    final field = EntityFactory.makeBSFPrintLabelLayoutFieldEntity(code: 0);
    final provider = printLabelLayoutAddFieldControllerProvider(layoutCode);
    final notifier = container.read(provider.notifier)..updateField(field);

    notifier.addField();

    expect(
      container
          .read(printLabelLayoutDetailsControllerProvider(layoutCode))
          .requireValue
          .fields,
      [field],
    );
  });
}
