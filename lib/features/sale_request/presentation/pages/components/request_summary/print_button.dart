// ignore_for_file: use_build_context_synchronously

import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/sale_request/presentation/pages/components/components.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PrintButton extends ConsumerStatefulWidget {
  final SaleRequestArgs args;
  const PrintButton({super.key, required this.args});

  @override
  ConsumerState<PrintButton> createState() => _PrintButtonState();
}

class _PrintButtonState extends ConsumerState<PrintButton> {
  bool _isLoading = false;

  void _showPrintPage() async {
    if (_isLoading) return;

    try {
      setState(() {
        _isLoading = true;
      });
      //* don't need to refresh because when loading the sale requests, already
      //* is doing it inside the controller
      final saleRequest = await ref.read(
        saleRequestDetailsStateControllerProvider(widget.args).future,
      );

      if (!context.mounted) return;

      if (saleRequest.code == null) {
        showSnackBarMessage(
          context,
          'Não foi possível carregar o pedido. Tente novamente'.hardcoded,
          backgroundColor: Colors.red,
        );
      } else {
        if (context.mounted) {
          await showAlertDialog(
            context: context,
            title: 'Imprimir pedido ${saleRequest.personalizedCode ?? ""}'
                .hardcoded,
            defaultActionText: '',
            actions: [],
            contentWidget: SingleChildScrollView(
              child: SizedBox(
                height: 200,
                child: IpToPrintPage(
                  enterpriseCode: widget.args.enterpriseCode,
                  saleRequestId: widget.args.saleRequestId,
                  customerCode: widget.args.customerCode,
                ),
              ),
            ),
          );
        }
      }
    } catch (e) {
      showSnackBarMessage(context, e.toString(), backgroundColor: Colors.red);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PrimaryButton(
      text: 'Imprimir'.hardcoded,
      icon: _isLoading
          ? const LoadingWidget()
          : const PlatformIcon(
              cupertinoIcon: CupertinoIcons.printer,
              materialIcon: Icons.print,
            ),
      onPressed: _isLoading ? null : _showPrintPage,
    );
  }
}
