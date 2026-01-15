import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../../../../routing/routing.dart';
import '../../../../domain/entities/entities.dart';

class DocumentsItems extends StatelessWidget {
  final List<ExpeditionDocumentEntity> documents;
  final VoidCallback? onRefresh;
  final int enterpriseCode;
  const DocumentsItems({
    super.key,
    required this.documents,
    required this.onRefresh,
    required this.enterpriseCode,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        onRefresh?.call();
      },
      child: ListView.builder(
        itemCount: documents.length,
        itemBuilder: (_, index) {
          final document = documents[index];
          return _DocumentItem(
            key: ValueKey(document.DocumentNumber),
            document: document,
            enterpriseCode: enterpriseCode,
          );
        },
      ),
    );
  }
}

class _DocumentItem extends StatelessWidget {
  final ExpeditionDocumentEntity document;
  final int enterpriseCode;
  const _DocumentItem({
    super.key,
    required this.document,
    required this.enterpriseCode,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            context.goNamed(
              Routes.expeditionConferenceProducts.name,
              pathParameters: {
                'expeditionControlCode':
                    document.ExpeditionControlCode.toString(),
                'stepCode': document.StepCode.toString(),
                'documentNumber': document.DocumentNumber.toString(),
                'enterpriseCode': enterpriseCode.toString(),
              },
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(Sizes.p8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TitleAndSubTitle(
                  title: 'Documento'.hardcoded,
                  subTitle: document.DocumentNumber,
                ),
                TitleAndSubTitle(
                  title: 'Etapa'.hardcoded,
                  subTitle: document.StepName,
                ),
                TitleAndSubTitle(
                  title: 'Origem'.hardcoded,
                  subTitle: document.OriginTypeString,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
