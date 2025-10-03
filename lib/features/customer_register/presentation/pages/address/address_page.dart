import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../core/validators/validators.dart';

class AddressPage extends ConsumerWidget {
  final TextEditingController cepController;
  const AddressPage({required this.cepController, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text('Endereços'.hardcoded)),
      body: ResponsiveScrollableWidget(
        child: Column(
          children: [
            DefaultTextFormField(
              controller: cepController,
              maxLength: 8,
              labelText: 'CEP'.hardcoded,
              hintText: 'CEP'.hardcoded,
              suffixIcon: PrimaryTextButton(
                text: 'Pesquisar CEP'.hardcoded,
                onPressed: () {
                  //TODO seek CEP
                },
              ),
              keyboardType: TextInputType.numberWithOptions(
                decimal: false,
              ), //TODO test in iOS
              validator: FormValidators.compose([
                NonEmptyValidator(),
                NumberValidator(allowDecimal: false),
                MinLengthValidator(8),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
