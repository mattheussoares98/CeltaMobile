import 'package:flutter/material.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../../../../core/validators/validators.dart';
import '../../../../../../localization/string_hardcoded.dart';

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
          DefaultTextFormField(
            labelText: 'HTTP remoto'.hardcoded,
            hintText: 'HTTP remoto'.hardcoded,
            controller: remoteHttpUrlController,
            maxLength: 100,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: TextInputType.url,
            validator: FormValidators.compose([UrlValidator()]),
          ),
          DefaultTextFormField(
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
          DefaultTextFormField(
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
          DefaultTextFormField(
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
