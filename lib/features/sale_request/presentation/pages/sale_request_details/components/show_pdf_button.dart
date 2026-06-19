import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/sale_request/providers.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/routing/routing.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ShowPdfButton extends ConsumerStatefulWidget {
  const ShowPdfButton({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ShowPdfButtonState();
}

class _ShowPdfButtonState extends ConsumerState<ShowPdfButton> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final args = ref.watch(saleRequestArgsProvider);
    final (loadedCorrectly, personalizedCode) = ref.watch(
      saleRequestDetailsStateControllerProvider(
        args,
      ).select((s) => (s.hasValue && !s.isLoading, s.value?.personalizedCode)),
    );

    return IconButton(
      onPressed: isLoading || !loadedCorrectly
          ? null
          : () async {
              setState(() {
                isLoading = true;
              });
              final bytes = await ref.read(
                pdfFromSaleRequestDetailsStateControllerProvider(args).future,
              );

              if (!context.mounted) return;

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
                    'fileName': personalizedCode,
                  },
                );
              }
              setState(() {
                isLoading = false;
              });
            },
      icon: isLoading
          ? const FittedBox(child: LoadingWidget())
          : PlatformIcon(
              cupertinoIcon: CupertinoIcons.doc_text_search,
              materialIcon: Icons.picture_as_pdf_rounded,
              color: loadedCorrectly ? null : context.theme.disabledColor,
            ),
    );
  }
}
