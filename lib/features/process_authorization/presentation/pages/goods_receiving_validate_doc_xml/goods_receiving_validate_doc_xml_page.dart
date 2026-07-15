import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/features/process_authorization/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/receipt/domain/entity/entity.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GoodsReceivingValidateDocXmlPage extends ConsumerWidget {
  final int processCode;
  const GoodsReceivingValidateDocXmlPage({
    super.key,
    required this.processCode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = gRDocFiscalNoteDifferencesStateControllerProvider(
      processCode,
    );
    return BaseScaffold(
      isScrollable: false,
      refreshProvider: provider,
      appBar: BaseAppBar(title: 'Diferenças de XML'.hardcoded),
      body: AsyncValueWidget(
        value: ref.watch(provider),
        tryAgain: () => ref.invalidate(provider),
        data: (data) {
          if (data.products?.isEmpty ?? true) {
            return BaseText.error(
              'Houve um erro não esperado para carregar os produtos'.hardcoded,
            );
          }

          return ScrollableTable<BSFGoodsReceivingProductEntity>(
            items: data.products!,
            fixFirstColumn: true,
            rowHeight: 45,
            refreshProvider: provider,
            columns: [
              ScrollableTableColumnSpec<BSFGoodsReceivingProductEntity>(
                headerTitle: 'Produto'.hardcoded,
                minWidth: 170.0,
                cellBuilder: (item) => BaseRichText(
                  texts: [
                    BaseText.title(
                      item.productString,
                      color: context.theme.primaryColor,
                    ),
                  ],
                  maxLines: 2,
                ),
                sortValueMapper: (item) => item.productString,
              ),
            ],
          );
        },
      ),
    );
  }
}
