import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../controllers/controllers.dart';
import 'components/components.dart';

class DocumentsPage extends ConsumerWidget {
  final int enterpriseCode;
  const DocumentsPage({super.key, required this.enterpriseCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void onRefresh() {
      ref.invalidate(
        expeditionDocumentsStateControllerProvider(enterpriseCode),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: DefaultAppBarTitle(title: 'Documentos'.hardcoded),
        actions: [
          ReloadIconButton(
            provider: expeditionDocumentsStateControllerProvider(
              enterpriseCode,
            ),
          ),
        ],
      ),
      body: Consumer(
        builder: (context, ref, child) {
          return AsyncValueWidget(
            value: ref.watch(
              expeditionDocumentsStateControllerProvider(enterpriseCode),
            ),
            tryAgain: onRefresh,
            data: (documents) {
              if (documents == null || documents.isEmpty) {
                return EmptyDocumentsMessage(onRefresh: onRefresh);
              }

              return DocumentsItems(
                documents: documents,
                onRefresh: onRefresh,
                enterpriseCode: enterpriseCode,
              );
            },
          );
        },
      ),
    );
  }
}
