import 'package:celta_inventario/utils/utils.dart';
import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/validators/validators.dart';
import 'package:flutter/material.dart';

class UrlsFields extends StatelessWidget {
  final TextEditingController remoteHttpUrlController;
  final TextEditingController remoteHttpsUrlController;
  final TextEditingController localHttpUrlController;
  final TextEditingController localHttpsUrlController;
  const UrlsFields({
    super.key,
    required this.remoteHttpUrlController,
    required this.remoteHttpsUrlController,
    required this.localHttpUrlController,
    required this.localHttpsUrlController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Sizes.p8),
      child: Column(
        children: [
          BaseTextFormField(
            labelText: context.l10n.remoteHttp2,
            hintText: context.l10n.remoteHttp2,
            controller: remoteHttpUrlController,
            maxLength: 100,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: TextInputType.url,
            validator: FormValidators.compose([
              UrlValidator(translations: context.l10n),
            ]),
          ),
          gapH8,
          BaseTextFormField(
            labelText: context.l10n.remoteHttps2,
            hintText: context.l10n.remoteHttps2,
            controller: remoteHttpsUrlController,
            maxLength: 100,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: TextInputType.url,
            validator: FormValidators.compose([
              UrlValidator(
                translations: context.l10n,
                shouldBeHttps: true,
                allowEmptyValue: true,
              ),
            ]),
          ),
          gapH8,
          BaseTextFormField(
            labelText: context.l10n.localHttp,
            hintText: context.l10n.localHttp,
            controller: localHttpUrlController,
            maxLength: 100,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: TextInputType.url,
            validator: FormValidators.compose([
              UrlValidator(translations: context.l10n, allowEmptyValue: true),
            ]),
          ),
          gapH8,
          BaseTextFormField(
            labelText: context.l10n.localHttps,
            hintText: context.l10n.localHttps,
            controller: localHttpsUrlController,
            maxLength: 100,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: TextInputType.url,
            validator: FormValidators.compose([
              UrlValidator(
                translations: context.l10n,
                shouldBeHttps: true,
                allowEmptyValue: true,
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
