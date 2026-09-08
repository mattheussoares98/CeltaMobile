import 'dart:math';

import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/exceptions/exceptions.dart';
import 'package:celta_inventario/features/enterprises/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/print_label_layout/domain/entities/entities.dart';
import 'package:celta_inventario/features/print_label_layout/domain/validators/validators.dart';
import 'package:celta_inventario/features/print_label_layout/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/print_label_layout/presentation/models/models.dart';
import 'package:celta_inventario/features/print_label_layout/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'print_label_problem_report_controller.g.dart';

@riverpod
class PrintLabelProblemReportController
    extends _$PrintLabelProblemReportController {
  PrintLabelProblemReportState get _value => state.requireValue;

  @override
  FutureOr<PrintLabelProblemReportState> build(int layoutCode) async {
    final userSession = await ref.watch(validatedUserSessionProvider.future);
    final selectedEnterprise = ref.watch(
      selectedEnterpriseStateControllerProvider,
    );
    final detailsProvider = printLabelLayoutDetailsControllerProvider(
      layoutCode,
    );
    final savedLayout = await ref.watch(detailsProvider.future);
    final environment = await ref
        .watch(printLabelProblemReportEnvironmentServiceProvider)
        .load();
    final supabaseEnterprise = userSession?.enterprise;
    if (supabaseEnterprise?.id == null ||
        userSession?.user.name == null ||
        selectedEnterprise?.Code == null) {
      throw AppException('The report context could not be loaded');
    }

    return PrintLabelProblemReportState(
      stage: PrintLabelProblemReportStage.snapshot,
      idempotencyKey: _newUuid(),
      supabaseEnterpriseId: supabaseEnterprise!.id!,
      erpEnterpriseCode: selectedEnterprise!.Code!,
      erpUserName: userSession!.user.name!,
      erpEnterpriseName: selectedEnterprise.name,
      savedLayout: savedLayout,
      environment: environment,
      description: '',
      captureConfirmation:
          const PrintLabelProblemReportCaptureConfirmationEntity(
            physicalLabelWasPrintedFromSavedLayout: false,
            canvasPreviewRepresentsSavedLayout: false,
          ),
    );
  }

  void confirmSnapshot() {
    if (_value.stage != PrintLabelProblemReportStage.snapshot) return;
    if (_value.savedLayout.code <= 0) {
      _setFailure(AppException('Only a saved layout can be reported'));
      return;
    }
    state = AsyncData(
      _value.copyWith(
        stage: PrintLabelProblemReportStage.images,
        clearError: true,
      ),
    );
  }

  Future<void> preparePhysicalLabel(String sourcePath) async {
    try {
      final image = await ref
          .read(printLabelProblemReportImageServiceProvider)
          .preparePhysicalPhoto(sourcePath);
      state = AsyncData(
        _value.copyWith(
          stage: PrintLabelProblemReportStage.images,
          physicalLabel: image,
          clearError: true,
        ),
      );
    } catch (error, stackTrace) {
      _setFailure(error, stackTrace);
    }
  }

  Future<void> prepareCanvasPreview(String sourcePath) async {
    try {
      final image = await ref
          .read(printLabelProblemReportImageServiceProvider)
          .prepareCanvas(sourcePath);
      state = AsyncData(
        _value.copyWith(
          stage: PrintLabelProblemReportStage.images,
          canvasPreview: image,
          clearError: true,
        ),
      );
    } catch (error, stackTrace) {
      _setFailure(error, stackTrace);
    }
  }

  void confirmImages() {
    if (_value.physicalLabel == null || _value.canvasPreview == null) {
      _setFailure(AppException('Both report images must be informed'));
      return;
    }
    state = AsyncData(
      _value.copyWith(
        stage: PrintLabelProblemReportStage.confirmations,
        clearError: true,
      ),
    );
  }

  void updateCaptureConfirmation({
    required bool physicalLabelWasPrintedFromSavedLayout,
    required bool canvasPreviewRepresentsSavedLayout,
  }) {
    state = AsyncData(
      _value.copyWith(
        captureConfirmation: PrintLabelProblemReportCaptureConfirmationEntity(
          physicalLabelWasPrintedFromSavedLayout:
              physicalLabelWasPrintedFromSavedLayout,
          canvasPreviewRepresentsSavedLayout:
              canvasPreviewRepresentsSavedLayout,
        ),
        clearError: true,
      ),
    );
  }

  void updateDescription(String description) {
    state = AsyncData(
      _value.copyWith(description: description, clearError: true),
    );
  }

  void showReview() {
    if (!_value.captureConfirmation.isConfirmed) {
      _setFailure(AppException('Both captures must be confirmed'));
      return;
    }
    state = AsyncData(
      _value.copyWith(
        stage: PrintLabelProblemReportStage.review,
        clearError: true,
      ),
    );
  }

  Future<void> retakeImages() async {
    if (_value.isSubmitting) return;
    await ref
        .read(printLabelProblemReportImageServiceProvider)
        .cleanup(_value.temporaryFilePaths);
    state = AsyncData(
      _value.copyWith(
        stage: PrintLabelProblemReportStage.snapshot,
        captureConfirmation:
            const PrintLabelProblemReportCaptureConfirmationEntity(
              physicalLabelWasPrintedFromSavedLayout: false,
              canvasPreviewRepresentsSavedLayout: false,
            ),
        clearImages: true,
        clearError: true,
      ),
    );
  }

  Future<void> submit() async {
    if (_value.isSubmitting ||
        _value.stage == PrintLabelProblemReportStage.result ||
        _value.stage == PrintLabelProblemReportStage.cancelled) {
      return;
    }

    final physicalLabel = _value.physicalLabel;
    final canvasPreview = _value.canvasPreview;
    if (physicalLabel == null || canvasPreview == null) {
      _setFailure(AppException('Both report images must be informed'));
      return;
    }

    final report = PrintLabelProblemReportEntity(
      schemaVersion: PrintLabelProblemReportValidator.schemaVersion,
      idempotencyKey: _value.idempotencyKey,
      supabaseEnterpriseId: _value.supabaseEnterpriseId,
      erpEnterpriseCode: _value.erpEnterpriseCode,
      erpUserName: _value.erpUserName,
      erpEnterpriseName: _value.erpEnterpriseName,
      description: _value.description.trim(),
      savedLayout: _value.savedLayout,
      environment: _value.environment,
      physicalLabel: physicalLabel.metadata,
      canvasPreview: canvasPreview.metadata,
      captureConfirmation: _value.captureConfirmation,
    );
    final validationErrors = PrintLabelProblemReportValidator.validate(report);
    if (validationErrors.isNotEmpty) {
      _setFailure(AppException(validationErrors.join('\n')));
      return;
    }

    state = AsyncData(
      _value.copyWith(
        stage: PrintLabelProblemReportStage.submitting,
        clearError: true,
        clearResult: true,
      ),
    );
    try {
      final imageService = ref.read(
        printLabelProblemReportImageServiceProvider,
      );
      final repository = ref.read(printLabelProblemReportRepositoryProvider);
      final result = await repository.submit(
        report: report,
        physicalLabelWebp: await imageService.readBytes(physicalLabel.filePath),
        canvasPreviewWebp: await imageService.readBytes(canvasPreview.filePath),
      );
      try {
        await imageService.cleanup(_value.temporaryFilePaths);
      } catch (_) {}
      state = AsyncData(
        _value.copyWith(
          stage: PrintLabelProblemReportStage.result,
          result: result,
          clearError: true,
        ),
      );
    } catch (error, stackTrace) {
      _setFailure(error, stackTrace);
    }
  }

  Future<void> retry() => submit();

  Future<void> cancel() async {
    if (_value.isSubmitting ||
        _value.stage == PrintLabelProblemReportStage.result ||
        _value.stage == PrintLabelProblemReportStage.cancelled) {
      return;
    }
    await ref
        .read(printLabelProblemReportImageServiceProvider)
        .cleanup(_value.temporaryFilePaths);
    state = AsyncData(
      _value.copyWith(
        stage: PrintLabelProblemReportStage.cancelled,
        clearError: true,
        clearResult: true,
      ),
    );
  }

  void _setFailure(Object error, [StackTrace? stackTrace]) {
    state = AsyncData(
      _value.copyWith(
        stage: PrintLabelProblemReportStage.failure,
        error: error,
        stackTrace: stackTrace ?? StackTrace.current,
      ),
    );
  }

  static String _newUuid() {
    final random = Random.secure();
    final bytes = List<int>.generate(16, (_) => random.nextInt(256));
    bytes[6] = (bytes[6] & 0x0f) | 0x40;
    bytes[8] = (bytes[8] & 0x3f) | 0x80;
    final hex = bytes
        .map((value) => value.toRadixString(16).padLeft(2, '0'))
        .join();
    return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-'
        '${hex.substring(12, 16)}-${hex.substring(16, 20)}-'
        '${hex.substring(20)}';
  }
}
