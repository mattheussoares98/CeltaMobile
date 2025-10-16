import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../core/presentation/controllers/user_session/user_session.dart';
import '../../controllers/controllers.dart';
import 'components/components.dart';

class DocumentsPage extends ConsumerWidget {
  final int enterpriseCode;
  const DocumentsPage({super.key, required this.enterpriseCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enterpriseName =
        ref.watch(validatedUserSessionProvider).value?.enterprise?.name ?? '';

    final value = ref.watch(
      expeditionDocumentsStateControllerProvider(
        enterpriseCode,
        enterpriseName,
      ),
    );

    void onRefresh() {
      ref.invalidate(
        expeditionDocumentsStateControllerProvider(
          enterpriseCode,
          enterpriseName,
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
            enterpriseCode: enterpriseCode,
          );
        },
      ),
    );
  }
}
