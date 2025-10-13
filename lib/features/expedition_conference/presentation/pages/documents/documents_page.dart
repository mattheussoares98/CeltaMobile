import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../core/domain/entities/entities.dart';
import '../../controllers/controllers.dart';
import 'components/components.dart';

class DocumentsPage extends ConsumerWidget {
  final int enterpriseCode;
  final EnterpriseEntity? selectedEnterprise;
  const DocumentsPage({
    super.key,
    required this.enterpriseCode,
    required this.selectedEnterprise,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(
      expeditionDocumentsStateControllerProvider(
        enterpriseCode,
        selectedEnterprise?.name ?? '',
      ),
    );

    void onRefresh() {
      ref.invalidate(
        expeditionDocumentsStateControllerProvider(
          enterpriseCode,
          selectedEnterprise?.name ?? '',
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Documentos'.hardcoded)),
      body: AsyncValueWidget(
        value: value,
        tryAgain: onRefresh,
        data: (documents) {
          if (documents == null || documents.isEmpty) {
            return EmptyDocumentsMessage(onRefresh: onRefresh);
          }

          return DocumentsItems(
            documents: documents,
            onRefresh: onRefresh,
            selectedEnterprise: selectedEnterprise,
          );
        },
      ),
    );
  }
}
