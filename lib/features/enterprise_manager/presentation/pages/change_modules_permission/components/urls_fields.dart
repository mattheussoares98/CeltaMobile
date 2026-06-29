import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/validators/validators.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
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
            labelText: 'HTTP remoto'.hardcoded,
            hintText: 'HTTP remoto'.hardcoded,
            controller: remoteHttpUrlController,
            maxLength: 100,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: TextInputType.url,
            validator: FormValidators.compose([UrlValidator()]),
          ),
          gapH8,
          BaseTextFormField(
            labelText: 'HTTPS remoto'.hardcoded,
            hintText: 'HTTPS remoto'.hardcoded,
            controller: remoteHttpsUrlController,
            maxLength: 100,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: TextInputType.url,
            validator: FormValidators.compose([
              UrlValidator(shouldBeHttps: true, allowEmptyValue: true),
            ]),
          ),
          gapH8,
          BaseTextFormField(
            labelText: 'HTTP local'.hardcoded,
            hintText: 'HTTP local'.hardcoded,
            controller: localHttpUrlController,
            maxLength: 100,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: TextInputType.url,
            validator: FormValidators.compose([
              UrlValidator(allowEmptyValue: true),
            ]),
          ),
          gapH8,
          BaseTextFormField(
            labelText: 'HTTPS local'.hardcoded,
            hintText: 'HTTPS local'.hardcoded,
            controller: localHttpsUrlController,
            maxLength: 100,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: TextInputType.url,
            validator: FormValidators.compose([
              UrlValidator(shouldBeHttps: true, allowEmptyValue: true),
            ]),
          ),
        ],
      ),
    );
  }
}
