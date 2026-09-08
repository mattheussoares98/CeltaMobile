import 'dart:async';

import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/core/providers/ec_request_params/ec_request_params.dart';
import 'package:celta_inventario/features/enterprises/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/print_label_layout/domain/entities/entities.dart';
import 'package:celta_inventario/features/print_label_layout/domain/repositories/repositories.dart';
import 'package:celta_inventario/features/print_label_layout/domain/services/services.dart';
import 'package:celta_inventario/features/print_label_layout/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/print_label_layout/presentation/models/models.dart';
import 'package:celta_inventario/features/print_label_layout/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

typedef SubmitHandler =
    Future<PrintLabelProblemReportSubmissionResultEntity> Function(
      PrintLabelProblemReportEntity report,
      List<int> physicalLabelWebp,
      List<int> canvasPreviewWebp,
    );

class FakePrintLabelProblemReportRepository
    implements IPrintLabelProblemReportRepository {
  SubmitHandler? handler;
  final List<PrintLabelProblemReportEntity> submittedReports = [];

  @override
  Future<PrintLabelProblemReportSubmissionResultEntity> submit({
    required PrintLabelProblemReportEntity report,
    required List<int> physicalLabelWebp,
    required List<int> canvasPreviewWebp,
  }) {
    submittedReports.add(report);
    return handler!(report, physicalLabelWebp, canvasPreviewWebp);
  }
}

class MockEcPrintLabelLayoutRepository extends Mock
    implements IEcPrintLabelLayoutRepository {}

class FakePrintLabelProblemReportEnvironmentService
    implements IPrintLabelProblemReportEnvironmentService {
  final PrintLabelProblemReportEnvironmentEntity environment;

  const FakePrintLabelProblemReportEnvironmentService(this.environment);

  @override
  Future<PrintLabelProblemReportEnvironmentEntity> load() async => environment;
}

class FakePrintLabelProblemReportImageService
    implements IPrintLabelProblemReportImageService {
  late PrintLabelProblemReportPreparedImageEntity physicalLabel;
  late PrintLabelProblemReportPreparedImageEntity canvasPreview;
  Object? preparationError;
  final Map<String, List<int>> bytesByPath = {};
  final List<List<String>> cleanupCalls = [];

  @override
  Future<void> cleanup(Iterable<String> filePaths) async {
    cleanupCalls.add(filePaths.toList());
  }

  @override
  Future<PrintLabelProblemReportPreparedImageEntity> prepareCanvas(
    String sourcePath,
  ) async {
    if (preparationError != null) throw preparationError!;
    return canvasPreview;
  }

  @override
  Future<PrintLabelProblemReportPreparedImageEntity> preparePhysicalPhoto(
    String sourcePath,
  ) async {
    if (preparationError != null) throw preparationError!;
    return physicalLabel;
  }

  @override
  Future<List<int>> readBytes(String filePath) async => bytesByPath[filePath]!;
}

void main() {
  late FakePrintLabelProblemReportRepository repository;
  late FakePrintLabelProblemReportImageService imageService;
  late MockEcPrintLabelLayoutRepository layoutRepository;
  late BSFPrintLabelLayoutEntity savedLayout;
  late PrintLabelProblemReportEnvironmentEntity environment;
  late EcRequestParams ecRequestParams;
  late UserSessionModel userSession;
  late EnterpriseEntity selectedEnterprise;
  late PrintLabelProblemReportPreparedImageEntity physicalLabel;
  late PrintLabelProblemReportPreparedImageEntity canvasPreview;

  PrintLabelProblemReportControllerProvider makeProvider() =>
      printLabelProblemReportControllerProvider(savedLayout.code);

  ProviderContainer makeContainer() => ProviderContainer(
    retry: (retryCount, error) => null,
    overrides: [
      printLabelProblemReportRepositoryProvider.overrideWithValue(repository),
      printLabelProblemReportImageServiceProvider.overrideWithValue(
        imageService,
      ),
      printLabelProblemReportEnvironmentServiceProvider.overrideWithValue(
        FakePrintLabelProblemReportEnvironmentService(environment),
      ),
      validatedUserSessionProvider.overrideWith(
        () => FakeValidatedUserSession(userSession),
      ),
      selectedEnterpriseStateControllerProvider.overrideWith(
        () => FakeSelectedEnterpriseStateController(selectedEnterprise),
      ),
      ecRequestParamsProvider().overrideWith((ref) => ecRequestParams),
      ecPrintLabelLayoutRepositoryProvider.overrideWithValue(layoutRepository),
    ],
  );

  Future<PrintLabelProblemReportController> prepareReview(
    ProviderContainer container,
  ) async {
    final provider = makeProvider();
    await container.read(provider.future);
    final controller = container.read(provider.notifier);
    controller.confirmSnapshot();
    await controller.preparePhysicalLabel('physical-source');
    await controller.prepareCanvasPreview('canvas-source');
    controller.confirmImages();
    controller.updateCaptureConfirmation(
      physicalLabelWasPrintedFromSavedLayout: true,
      canvasPreviewRepresentsSavedLayout: true,
    );
    controller.updateDescription(' Report description ');
    controller.showReview();
    return controller;
  }

  setUp(() {
    repository = FakePrintLabelProblemReportRepository();
    imageService = FakePrintLabelProblemReportImageService();
    layoutRepository = MockEcPrintLabelLayoutRepository();
    savedLayout = EntityFactory.makeBSFPrintLabelLayoutEntity(code: 42);
    environment = EntityFactory.makePrintLabelProblemReportEnvironmentEntity();
    ecRequestParams = EntityFactory.makeEcRequestParams();
    userSession = UserSessionModel.fromEntity(
      EntityFactory.makeUserSessionEntity(),
    );
    selectedEnterprise = EntityFactory.makeEnterpriseEntity(
      code: 12,
      name: 'ERP enterprise',
    );
    when(
      () => layoutRepository.getDetails(ecRequestParams, savedLayout.code),
    ).thenAnswer((_) async => savedLayout);
    physicalLabel =
        EntityFactory.makePrintLabelProblemReportPreparedImageEntity(
          filePath: 'physical.webp',
        );
    canvasPreview =
        EntityFactory.makePrintLabelProblemReportPreparedImageEntity(
          filePath: 'canvas.webp',
        );
    imageService
      ..physicalLabel = physicalLabel
      ..canvasPreview = canvasPreview
      ..bytesByPath[physicalLabel.filePath] = [1, 2]
      ..bytesByPath[canvasPreview.filePath] = [3, 4];
  });

  test(
    'build starts at snapshot with a valid version-4 idempotency key',
    () async {
      final container = makeContainer();
      addTearDown(container.dispose);

      final state = await container.read(makeProvider().future);

      expect(state.stage, PrintLabelProblemReportStage.snapshot);
      expect(state.savedLayout, savedLayout);
      expect(
        state.idempotencyKey,
        matches(
          RegExp(
            r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
          ),
        ),
      );
    },
  );

  test('workflow reaches images, confirmations, and review states', () async {
    final container = makeContainer();
    addTearDown(container.dispose);
    final provider = makeProvider();
    await container.read(provider.future);
    final controller = container.read(provider.notifier);

    controller.confirmSnapshot();
    expect(
      container.read(provider).requireValue.stage,
      PrintLabelProblemReportStage.images,
    );

    await controller.preparePhysicalLabel('physical-source');
    await controller.prepareCanvasPreview('canvas-source');
    controller.confirmImages();
    expect(
      container.read(provider).requireValue.stage,
      PrintLabelProblemReportStage.confirmations,
    );

    controller.updateCaptureConfirmation(
      physicalLabelWasPrintedFromSavedLayout: true,
      canvasPreviewRepresentsSavedLayout: true,
    );
    controller.updateDescription('Problem');
    controller.showReview();
    expect(
      container.read(provider).requireValue.stage,
      PrintLabelProblemReportStage.review,
    );
  });

  test('incomplete images and confirmations expose failure state', () async {
    final container = makeContainer();
    addTearDown(container.dispose);
    final provider = makeProvider();
    await container.read(provider.future);
    final controller = container.read(provider.notifier);

    controller.confirmImages();
    expect(
      container.read(provider).requireValue.stage,
      PrintLabelProblemReportStage.failure,
    );
    expect(
      container.read(provider).requireValue.error.toString(),
      contains('images'),
    );

    controller.showReview();
    expect(
      container.read(provider).requireValue.stage,
      PrintLabelProblemReportStage.failure,
    );
    expect(
      container.read(provider).requireValue.error.toString(),
      contains('confirmed'),
    );
    expect(repository.submittedReports, isEmpty);
  });

  test(
    'image preparation failure preserves files and exposes failure',
    () async {
      final exception = Exception('conversion failed');
      imageService.preparationError = exception;
      final container = makeContainer();
      addTearDown(container.dispose);
      final provider = makeProvider();
      await container.read(provider.future);

      await container
          .read(provider.notifier)
          .preparePhysicalLabel('physical-source');

      expect(
        container.read(provider).requireValue.stage,
        PrintLabelProblemReportStage.failure,
      );
      expect(container.read(provider).requireValue.error, exception);
      expect(imageService.cleanupCalls, isEmpty);
    },
  );

  test(
    'submission ignores duplicate taps and cleans files after success',
    () async {
      final result =
          EntityFactory.makePrintLabelProblemReportSubmissionResultEntity();
      final completer =
          Completer<PrintLabelProblemReportSubmissionResultEntity>();
      repository.handler = (report, physicalBytes, canvasBytes) {
        expect(physicalBytes, [1, 2]);
        expect(canvasBytes, [3, 4]);
        return completer.future;
      };
      final container = makeContainer();
      addTearDown(container.dispose);
      final provider = makeProvider();
      final controller = await prepareReview(container);

      final first = controller.submit();
      final duplicate = controller.submit();
      expect(
        container.read(provider).requireValue.stage,
        PrintLabelProblemReportStage.submitting,
      );
      completer.complete(result);
      await Future.wait([first, duplicate]);

      final state = container.read(provider).requireValue;
      final submittedReport = repository.submittedReports.single;
      expect(state.stage, PrintLabelProblemReportStage.result);
      expect(state.result, result);
      expect(submittedReport.description, 'Report description');
      expect(submittedReport.idempotencyKey, state.idempotencyKey);
      expect(repository.submittedReports, [submittedReport]);
      expect(imageService.cleanupCalls, [
        [physicalLabel.filePath, canvasPreview.filePath],
      ]);
    },
  );

  test('failure retains files and retry reuses the idempotency key', () async {
    final exception = Exception('network failed');
    final result =
        EntityFactory.makePrintLabelProblemReportSubmissionResultEntity();
    var attempt = 0;
    repository.handler = (report, physicalBytes, canvasBytes) async {
      expect(physicalBytes, [1, 2]);
      expect(canvasBytes, [3, 4]);
      if (attempt++ == 0) throw exception;
      return result;
    };
    final container = makeContainer();
    addTearDown(container.dispose);
    final provider = makeProvider();
    final controller = await prepareReview(container);

    await controller.submit();
    expect(
      container.read(provider).requireValue.stage,
      PrintLabelProblemReportStage.failure,
    );
    expect(container.read(provider).requireValue.error, exception);
    expect(imageService.cleanupCalls, isEmpty);

    await controller.retry();
    expect(
      container.read(provider).requireValue.stage,
      PrintLabelProblemReportStage.result,
    );
    expect(repository.submittedReports, hasLength(2));
    expect(
      repository.submittedReports
          .map((report) => report.idempotencyKey)
          .toSet(),
      hasLength(1),
    );
  });

  test('retake clears prepared images and their temporary files', () async {
    final container = makeContainer();
    addTearDown(container.dispose);
    final provider = makeProvider();
    await container.read(provider.future);
    final controller = container.read(provider.notifier);
    controller.confirmSnapshot();
    await controller.preparePhysicalLabel('physical-source');
    await controller.prepareCanvasPreview('canvas-source');

    await controller.retakeImages();

    final state = container.read(provider).requireValue;
    expect(state.stage, PrintLabelProblemReportStage.snapshot);
    expect(state.physicalLabel, isNull);
    expect(state.canvasPreview, isNull);
    expect(imageService.cleanupCalls, [
      [physicalLabel.filePath, canvasPreview.filePath],
    ]);
  });

  test(
    'explicit cancellation clears temporary files without submission',
    () async {
      final container = makeContainer();
      addTearDown(container.dispose);
      final provider = makeProvider();
      await container.read(provider.future);
      final controller = container.read(provider.notifier);
      controller.confirmSnapshot();
      await controller.preparePhysicalLabel('physical-source');
      await controller.prepareCanvasPreview('canvas-source');

      await controller.cancel();

      expect(
        container.read(provider).requireValue.stage,
        PrintLabelProblemReportStage.cancelled,
      );
      expect(imageService.cleanupCalls, [
        [physicalLabel.filePath, canvasPreview.filePath],
      ]);
      expect(repository.submittedReports, isEmpty);
    },
  );
}
