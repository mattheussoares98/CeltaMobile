import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/routing/routes.dart';
import 'package:flutter/cupertino.dart';
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

    setState(() {
      _isLoading = true;
    });
    final personalizedCode = await ref.read(
      saleRequestDetailsStateControllerProvider(
        widget.args,
      ).selectAsync((s) => s.personalizedCode),
    );
    final bytes = await ref.read(
      pdfFromSaleRequestDetailsStateControllerProvider(widget.args).future,
    );

    if (!context.mounted) return;

    if (bytes == null) {
      showAlertDialog(
        // ignore: use_build_context_synchronously
        context: context,
        title: 'Não foi possível gerar o PDF. Tente novamente'.hardcoded,
      );
    } else {
      // ignore: use_build_context_synchronously
      context.pushNamed(
        Routes.pdfViewer.name,
        extra: <String, dynamic>{'bytes': bytes, 'fileName': personalizedCode},
      );
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PrimaryButton(
      text: 'PDF'.hardcoded,
      icon: _isLoading
          ? const LoadingWidget()
          : const PlatformIcon(
              cupertinoIcon: CupertinoIcons.doc_text_search,
              materialIcon: Icons.picture_as_pdf_rounded,
            ),
      onPressed: _isLoading ? null : _buildPdf,
    );
  }
}
