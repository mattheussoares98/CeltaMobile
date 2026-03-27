import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../routing/routing.dart';
import '../../../controllers/controllers.dart';

class ShowPdfButton extends ConsumerStatefulWidget {
  final int enterpriseCode;
  final int customerCode;
  final int saleRequestCode;

  const ShowPdfButton({
    super.key,
    required this.enterpriseCode,
    required this.customerCode,
    required this.saleRequestCode,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ShowPdfButtonState();
}

class _ShowPdfButtonState extends ConsumerState<ShowPdfButton> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;

    final saleRequestDetails = ref
        .watch(
          saleRequestDetailsStateControllerProvider(
            enterpriseCode: widget.enterpriseCode,
            customerCode: widget.customerCode,
            saleRequestCode: widget.saleRequestCode,
          ),
        )
        .value;

    return IconButton(
      onPressed: isLoading || saleRequestDetails == null
          ? null
          : () async {
              setState(() {
                isLoading = true;
              });
              final bytes = await ref.read(
                pdfFromSaleRequestDetailsStateControllerProvider(
                  enterpriseCode: widget.enterpriseCode,
                  customerCode: widget.customerCode,
                  saleRequestCode: widget.saleRequestCode,
                ).future,
              );

              if (bytes == null) {
                showAlertDialog(
                  context: context,
                  title:
                      'Não foi possível gerar o PDF. Tente novamente'.hardcoded,
                );
              } else {
                context.pushNamed(
                  Routes.pdfViewer.name,
                  extra: <String, dynamic>{
                    'bytes': bytes,
                    'fileName': saleRequestDetails.personalizedCode,
                  },
                );
              }
              setState(() {
                isLoading = false;
              });
            },
      icon: isLoading
          ? const FittedBox(child: LoadingWidget(padding: 0))
          : Icon(
              isIOS
                  ? CupertinoIcons.doc_text_search
                  : Icons.picture_as_pdf_rounded,
              color: saleRequestDetails == null ? theme.disabledColor : null,
            ),
    );
  }
}
