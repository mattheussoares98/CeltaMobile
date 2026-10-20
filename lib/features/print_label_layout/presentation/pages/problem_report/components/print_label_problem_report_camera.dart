import 'package:celta_inventario/exceptions/exceptions.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'dart:io';

import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/print_label_layout/presentation/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:permission_handler/permission_handler.dart';

class PrintLabelProblemReportCamera extends HookWidget {
  final IPrintLabelCameraDelegate cameraDelegate;
  final ValueChanged<String> onPhotoConfirmed;

  const PrintLabelProblemReportCamera({
    super.key,
    required this.cameraDelegate,
    required this.onPhotoConfirmed,
  });

  @override
  Widget build(BuildContext context) {
    final error = useState<Object?>(null);
    final photoPath = useState<String?>(null);
    final isReady = useState(false);
    final isCapturing = useState(false);
    final confirmations = useState(<String, bool>{
      context.l10n.theEntireLabelIsVisible: false,
      context.l10n.thereIsARulerAboveOrBelowTheLabel: false,
      context.l10n.thePhotoIsInFocusAndHasNoGlare: false,
    });

    useEffect(() {
      var active = true;
      cameraDelegate
          .initialize()
          .then((_) {
            if (active) isReady.value = true;
          })
          .catchError((Object value) {
            if (active) error.value = value;
          });
      final lifecycleListener = AppLifecycleListener(
        onPause: () {
          isReady.value = false;
          cameraDelegate.pause();
        },
        onResume: () {
          cameraDelegate
              .resume()
              .then((_) {
                if (active) isReady.value = true;
              })
              .catchError((Object value) {
                if (active) error.value = value;
              });
        },
      );
      return () {
        active = false;
        lifecycleListener.dispose();
        cameraDelegate.dispose();
      };
    }, [cameraDelegate]);

    Future<void> takePicture() async {
      isCapturing.value = true;
      try {
        photoPath.value = await cameraDelegate.takePicture();
      } catch (value) {
        error.value = value;
      } finally {
        isCapturing.value = false;
      }
    }

    if (error.value != null) {
      final denied = cameraDelegate.isPermissionDenied(error.value!);
      return Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              BaseText.headline(
                denied
                    ? context.l10n.allowCameraAccessInYourDeviceSettings
                    : context.l10n.cameraOpenFailed(
                        parseErrorMessage(
                          error.value,
                          translations: context.l10n,
                        ),
                      ),
                textAlign: TextAlign.center,
              ),
              if (denied) ...[
                gapH8,
                PrimaryTextButton(
                  text: context.l10n.openSettings,
                  onPressed: openAppSettings,
                ),
              ],
            ],
          ),
        ),
      );
    }
    if (!isReady.value) return const LoadingWidget();

    if (photoPath.value != null) {
      return Column(
        key: const Key('print-label-photo-review'),
        children: [
          Expanded(
            child: Image.file(File(photoPath.value!), fit: BoxFit.contain),
          ),
          gapH8,
          Row(
            children: [
              Expanded(
                child: PrimaryTextButton(
                  text: context.l10n.takeAnotherPhoto,
                  onPressed: () => photoPath.value = null,
                ),
              ),
              gapW8,
              Expanded(
                child: PrimaryButton(
                  text: context.l10n.useThisPhoto,
                  onPressed: () => onPhotoConfirmed(photoPath.value!),
                ),
              ),
            ],
          ),
        ],
      );
    }

    return Column(
      children: [
        Expanded(child: cameraDelegate.buildPreview()),
        gapH8,
        for (final confirmation in confirmations.value.entries)
          BaseCheckBox(
            name: confirmation.key,
            enabled: confirmation.value,
            onChanged: isCapturing.value
                ? null
                : (value) {
                    final updated = {...confirmations.value};
                    updated[confirmation.key] = value ?? false;
                    confirmations.value = updated;
                  },
          ),
        gapH8,
        SizedBox(
          width: double.infinity,
          child: PrimaryButton(
            text: context.l10n.takePhoto,
            isLoading: isCapturing.value,
            onPressed: confirmations.value.values.every((value) => value)
                ? takePicture
                : null,
          ),
        ),
      ],
    );
  }
}
