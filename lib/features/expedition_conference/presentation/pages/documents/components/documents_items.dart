import 'package:celta_inventario/utils/utils.dart';
import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/expedition_conference/domain/entities/entities.dart';
import 'package:celta_inventario/routing/routing.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DocumentsItems extends StatelessWidget {
  final List<ExpeditionDocumentEntity> documents;
  final int enterpriseCode;
  const DocumentsItems({
    super.key,
    required this.documents,
    required this.enterpriseCode,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveListFlow(
      itemCount: documents.length,
      itemBuilder: (_, index) {
        final document = documents[index];
        return _DocumentItem(
          key: ValueKey(document.DocumentNumber),
          document: document,
          enterpriseCode: enterpriseCode,
        );
      },
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
    return Card(
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
                title: context.l10n.document,
                subTitle: document.DocumentNumber,
              ),
              TitleAndSubTitle(
                title: context.l10n.step,
                subTitle: document.StepName,
              ),
              TitleAndSubTitle(
                title: context.l10n.origin,
                subTitle: document.OriginTypeString,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
