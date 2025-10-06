import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:celta_intelligence/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../core/validators/validators.dart';
import '../../controllers/controllers.dart';

class AddressPage extends ConsumerWidget {
  final TextEditingController cepController;
  const AddressPage({required this.cepController, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<void> seekAddress() async {
      ref
          .read(getAddressByCepControllerProvider.notifier)
          .getAddress(cepController.text);
    }

    ref.listen(getAddressByCepControllerProvider, (p, n) {
      n.doOnSuccess(p, () {
        debugPrint(n.value.toString());
        //TODO update forms
      });
    });

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
              onChanged: (value) {
                if (value.length == 8) {
                  seekAddress();
                }
              },
              keyboardType: TextInputType.numberWithOptions(
                decimal: false,
              ), //TODO test in iOS
              onFieldSubmitted: (_) {
                seekAddress();
              },
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
