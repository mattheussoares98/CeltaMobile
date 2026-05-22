import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';

import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/validators/validators.dart';
import 'package:celta_inventario/features/sale_request/providers.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/controllers.dart';

class PrintButton extends ConsumerStatefulWidget {
  final int enterpriseCode;
  final int? saleRequestId;
  final int? customerCode;
  const PrintButton({
    super.key,
    required this.enterpriseCode,
    this.saleRequestId,
    this.customerCode,
  });

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

    if (widget.customerCode != null && widget.saleRequestId != null) {
      await ref
          .read(printSaleRequestControllerProvider.notifier)
          .bsfPrint(
            saleRequestCode: widget.saleRequestId!,
            customerCode: widget.customerCode!,
            enterpriseCode: widget.enterpriseCode,
            ip: ipController.text,
          );
    } else {
      await ref
          .read(printSaleRequestControllerProvider.notifier)
          .soapPrint(ipController.text);
    }
  }

  Future<void> _showModalPage(bool isSaleDetailsPage) async {
    showModalPage(
      Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  isSaleDetailsPage
                      ? 'Imprimir pedido'.hardcoded
                      : 'Imprimir último pedido salvo na empresa'.hardcoded,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                gapH16,
                Consumer(
                  builder: (_, ref, _) {
                    final isLoading = ref.watch(
                      printSaleRequestControllerProvider.select(
                        (s) => s.isLoading,
                      ),
                    );

                    return Column(
                      children: [
                        DefaultTextFormField(
                          labelText: 'IP da impressora'.hardcoded,
                          hintText: '192.168.0.1',
                          maxLength: 15,
                          controller: ipController,
                          enabled: !isLoading,
                          onFieldSubmitted: (_) => print(),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          inputFormatters: [
                            // This allows *only* digits and dots
                            FilteringTextInputFormatter.allow(RegExp(r'[\d.]')),
                          ],
                          validator: FormValidators.compose([
                            NonEmptyValidator(),
                            IpValidator(),
                          ]),
                          keyboardType: TextInputType.datetime,
                        ),
                        gapH32,
                        PrimaryButton(
                          text: 'Imprimir'.hardcoded,
                          isLoading: isLoading,
                          onPressed: () => print(),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      context,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isSaleDetailsPage =
        widget.customerCode != null && widget.saleRequestId != null;

    final ProviderBase<AsyncValue<dynamic>> provider = isSaleDetailsPage
        ? saleRequestDetailsStateControllerProvider(
            ref.read(saleRequestArgsProvider),
          )
        : lastSavedSaleRequestStateControllerProvider(widget.enterpriseCode);

    return Consumer(
      builder: (_, ref, _) {
        final canPrint = ref.watch(
          provider.select((s) => s.value != null && !s.isLoading),
        );

        return IconButton(
          icon: const PlatformIcon(
            cupertinoIcon: CupertinoIcons.printer,
            materialIcon: Icons.print,
          ),
          onPressed: canPrint ? () => _showModalPage(isSaleDetailsPage) : null,
        );
      },
    );
  }
}
