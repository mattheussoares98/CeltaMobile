import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/features/expedition_conference/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/expedition_conference/presentation/pages/documents/components/components.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

    return BaseScaffold(
      isScrollable: false,
      onRefresh: () => ref.refresh(
        expeditionDocumentsStateControllerProvider(enterpriseCode).future,
      ),
      appBar: DefaultAppBar(
        title: 'Documentos'.hardcoded,
        showSelectedEnterprise: true,
      ),
      body: Consumer(
        builder: (_, ref, _) {
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
                enterpriseCode: enterpriseCode,
              );
            },
          );
        },
      ),
    );
  }
}
