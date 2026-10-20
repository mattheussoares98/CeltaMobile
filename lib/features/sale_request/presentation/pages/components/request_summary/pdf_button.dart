import 'package:celta_inventario/utils/utils.dart';
// ignore_for_file: use_build_context_synchronously

import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class PdfButton extends ConsumerStatefulWidget {
  final SaleRequestArgs args;
  const PdfButton({super.key, required this.args});

  @override
  ConsumerState<PdfButton> createState() => _PdfButtonState();
}

class _PdfButtonState extends ConsumerState<PdfButton> {
  bool _isLoading = false;

  void _buildPdf() async {
    if (_isLoading) return;
    try {
      setState(() {
        _isLoading = true;
      });
      final saleRequest = await ref.read(
        saleRequestDetailsStateControllerProvider(widget.args).future,
      );
      //* don't need to refresh because when loading the sale requests, already
      //* is doing it inside the controller
      final bytes = await ref.read(
        pdfFromSaleRequestDetailsStateControllerProvider(widget.args).future,
      );

      if (!context.mounted) return;

      if (bytes == null) {
        showToastMessage(
          context.l10n.unableToGenerateThePdfTryAgain,
          type: ToastType.error,
        );
      } else {
        context.pushNamed(
          Routes.pdfViewer.name,
          extra: <String, dynamic>{
            'bytes': bytes,
            'fileName': saleRequest.personalizedCode,
          },
        );
      }
    } catch (e) {
      showToastMessage(e.toString(), type: ToastType.error);
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
      text: context.l10n.pdf,
      icon: _isLoading
          ? const LoadingWidget()
          : const PlatformIcon(
              cupertinoIcon: Icons.picture_as_pdf_rounded,
              materialIcon: Icons.picture_as_pdf_rounded,
            ),
      onPressed: _isLoading ? null : _buildPdf,
    );
  }
}
