import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../../../../core/validators/validators.dart';
import '../../../controllers/controllers.dart';

class PrintButton extends ConsumerStatefulWidget {
  final int enterpriseCode;
  const PrintButton({super.key, required this.enterpriseCode});

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
      showSnackBarMessage(context, 'Impressão eviada com sucesso'.hardcoded);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;

    return AsyncValueWidget(
      value: ref.watch(
        lastSavedSaleRequestStateControllerProvider(widget.enterpriseCode),
      ),
      tryAgain: () {
        ref.invalidate(
          lastSavedSaleRequestStateControllerProvider(widget.enterpriseCode),
        );
      },
      data: (lastSavedSaleRequest) {
        return IconButton(
          icon: Icon(
            isIOS ? CupertinoIcons.printer : Icons.print,
            color: lastSavedSaleRequest == null ? theme.disabledColor : null,
          ),
          onPressed: lastSavedSaleRequest == null
              ? () {
                  showAlertDialog(
                    context: context,
                    title: 'Nenhum pedido salvo encontrado'.hardcoded,
                    content:
                        'Só é possível imprimir o último pedido salvo, mas não foram encontrados pedidos salvos para esta empresa'
                            .hardcoded,
                    defaultActionText: 'Ok'.hardcoded,
                  );
                }
              : () {
                  showModalPage(
                    Consumer(
                      builder: (_, ref, _) {
                        final isLoading = ref.watch(
                          printLastSavedSaleRequestControllerProvider.select(
                            (s) => s.isLoading,
                          ),
                        );

                        return Form(
                          key: formKey,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  'Imprimir último pedido salvo na empresa'
                                      .hardcoded,
                                ),
                                const SizedBox(height: Sizes.p16),
                                DefaultTextFormField(
                                  labelText: 'IP da impressora'.hardcoded,
                                  hintText: '192.168.0.1',
                                  maxLength: 15,
                                  controller: ipController,
                                  enabled: !isLoading,
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
                                PrimaryButton(
                                  text: 'Imprimir'.hardcoded,
                                  isLoading: isLoading,
                                  onPressed: print,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    context,
                  );
                },
        );
      },
    );
  }
}
