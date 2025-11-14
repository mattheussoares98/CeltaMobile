import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../enterprises/presentation/controllers/controllers.dart';
import '../../../controllers/controllers.dart';

class ShowPdfButton extends ConsumerStatefulWidget {
  const ShowPdfButton({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ShowPdfButtonState();
}

class _ShowPdfButtonState extends ConsumerState<ShowPdfButton> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;

    final enterpriseCode = ref
        .watch(selectedEnterpriseStateControllerProvider)!
        .Code!;

    final lastSavedSaleRequest = ref
        .watch(lastSavedSaleRequestStateControllerProvider(enterpriseCode))
        .value;

    return IconButton(
      onPressed: isLoading || lastSavedSaleRequest == null
          ? null
          : () async {
              setState(() {
                isLoading = true;
              });
              final bytes = await ref.read(
                pdfFromLastSavedSaleRequestControllerProvider.future,
              );

              if (bytes == null) {
                showAlertDialog(
                  context: context,
                  title:
                      'Não foi possível gerar o PDF. Tente novamente'.hardcoded,
                );
              } else {
                //TODO open PDF viewer page
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
              color: lastSavedSaleRequest == null ? theme.disabledColor : null,
            ),
    );
  }
}
