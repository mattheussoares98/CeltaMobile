import 'dart:io';

import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/print_label_layout/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/print_label_layout/presentation/models/models.dart';
import 'package:celta_inventario/features/print_label_layout/presentation/pages/details/components/components.dart';
import 'package:celta_inventario/features/print_label_layout/presentation/pages/problem_report/components/components.dart';
import 'package:celta_inventario/features/print_label_layout/presentation/services/services.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart';

class PrintLabelProblemReportPage extends HookConsumerWidget {
  final int labelCode;
  final IPrintLabelCameraDelegate? cameraDelegate;
  final Future<String> Function()? captureCanvasPreview;

  const PrintLabelProblemReportPage({
    super.key,
    required this.labelCode,
    this.cameraDelegate,
    this.captureCanvasPreview,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = printLabelProblemReportControllerProvider(labelCode);
    final previewKey = useMemoized(GlobalKey.new);
    final delegate = useMemoized(
      () => cameraDelegate ?? PrintLabelCameraDelegate(),
    );
    const canvasCaptureService = PrintLabelCanvasCaptureService();

    Future<String> capturePreview() async {
      if (captureCanvasPreview != null) return captureCanvasPreview!();

      final renderObject = previewKey.currentContext?.findRenderObject();
      if (renderObject is! RenderRepaintBoundary) {
        throw StateError('The preview boundary could not be found');
      }

      // ignore: use_build_context_synchronously
      final pixelRatio = View.of(context).devicePixelRatio.clamp(1.0, 3.0);
      final data = await canvasCaptureService.capture(
        boundary: renderObject,
        pixelRatio: pixelRatio,
      );
      final directory = await getTemporaryDirectory();
      final file = File(
        '${directory.path}${Platform.pathSeparator}print-label-preview-$labelCode.png',
      );
      await file.writeAsBytes(data, flush: true);
      return file.path;
    }

    return BaseScaffold(
      isScrollable: false,
      appBar: BaseAppBar(title: 'Relatar problema de impressão'.hardcoded),
      padding: const EdgeInsets.all(Sizes.p8),
      body: AsyncValueWidget(
        value: ref.watch(provider),
        tryAgain: () => ref.invalidate(provider),
        data: (state) {
          final controller = ref.read(provider.notifier);
          switch (state.stage) {
            case PrintLabelProblemReportStage.snapshot:
              return Column(
                children: [
                  BaseText.titleLarge(
                    'Confira o leiaute salvo antes de fotografar.'.hardcoded,
                  ),
                  gapH8,
                  Expanded(
                    child: PrintLabelLayoutPreview(
                      layout: state.savedLayout,
                      showPreviewMessage: false,
                      canvasKey: previewKey,
                    ),
                  ),
                  gapH8,
                  SizedBox(
                    width: double.infinity,
                    child: PrimaryButton(
                      key: const Key('start-print-label-report-capture'),
                      text: 'Continuar'.hardcoded,
                      onPressed: () async {
                        final previewPath = await capturePreview();
                        controller.confirmSnapshot();
                        await controller.prepareCanvasPreview(previewPath);
                      },
                    ),
                  ),
                ],
              );
            case PrintLabelProblemReportStage.images:
              return PrintLabelProblemReportCamera(
                cameraDelegate: delegate,
                onPhotoConfirmed: (path) async {
                  await controller.preparePhysicalLabel(path);
                  controller.showReview();
                },
              );
            case PrintLabelProblemReportStage.review:
              return PrintLabelProblemReportReview(layoutCode: labelCode);
            case PrintLabelProblemReportStage.submitting:
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const LoadingWidget(),
                    gapH8,
                    BaseText.bodyMedium('Enviando relatório...'.hardcoded),
                  ],
                ),
              );
            case PrintLabelProblemReportStage.result:
              return PrintLabelProblemReportResult(layoutCode: labelCode);
            case PrintLabelProblemReportStage.failure:
              return PrintLabelProblemReportFailure(layoutCode: labelCode);
            case PrintLabelProblemReportStage.cancelled:
              return Center(
                child: BaseText.bodyMedium('Relatório cancelado.'.hardcoded),
              );
          }
        },
      ),
    );
  }
}
