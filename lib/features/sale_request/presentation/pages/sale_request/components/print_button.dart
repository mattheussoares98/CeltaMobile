import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../../../../core/validators/validators.dart';
import '../../../../../enterprises/presentation/controllers/controllers.dart';
import '../../../controllers/controllers.dart';

class PrintButton extends ConsumerStatefulWidget {
  const PrintButton({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PrintLastSavedSaleRequestButtonState();
}

class _PrintLastSavedSaleRequestButtonState extends ConsumerState<PrintButton> {
  final ipController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    ipController.dispose();
    super.dispose();
  }

  @override
  initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        final ip = await ref.read(ipPrintSaleRequestControllerProvider.future);

        ipController.text = ip ?? '';
      }
    });
  }

  void print() async {
    if (formKey.currentState?.validate() != true) {
      return;
    }

    final printed = await ref
        .read(printLastSavedSaleRequestControllerProvider.notifier)
        .print(ipController.text);

    if (printed) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final enterpriseCode = ref
        .watch(selectedEnterpriseStateControllerProvider)!
        .Code!;

    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;

    return AsyncValueWidget(
      value: ref.watch(
        lastSavedSaleRequestStateControllerProvider(enterpriseCode),
      ),
      tryAgain: () {
        ref.invalidate(
          lastSavedSaleRequestStateControllerProvider(enterpriseCode),
        );
      },
      data: (lastSavedSaleRequest) {
        return IconButton(
          onPressed: lastSavedSaleRequest == null
              ? null
              : () {
                  showModalPage(
                    Form(
                      key: formKey,
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  'Imprimir último pedido salvo para esta empresa?'
                                      .hardcoded,
                                ),
                                const SizedBox(height: Sizes.p16),
                                DefaultTextFormField(
                                  labelText: 'IP da impressora'.hardcoded,
                                  hintText: '192.168.0.1',
                                  maxLength: 15,
                                  controller: ipController,
                                  onFieldSubmitted: (_) => print(),
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  inputFormatters: [
                                    // This allows *only* digits and dots
                                    FilteringTextInputFormatter.allow(
                                      RegExp(r'[\d.]'),
                                    ),
                                  ],
                                  validator: FormValidators.compose([
                                    NonEmptyValidator(),
                                    IpValidator(),
                                  ]),
                                  keyboardType: TextInputType.datetime,
                                ),
                                const SizedBox(height: Sizes.p32),
                                Consumer(
                                  builder: (_, ref, _) {
                                    final isLoading = ref.watch(
                                      printLastSavedSaleRequestControllerProvider
                                          .select((s) => s.isLoading),
                                    );

                                    return PrimaryButton(
                                      text: 'Imprimir'.hardcoded,
                                      isLoading: isLoading,
                                      onPressed: print,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    context,
                  );
                },
          icon: Icon(isIOS ? CupertinoIcons.printer : Icons.print),
        );
      },
    );
  }
}
