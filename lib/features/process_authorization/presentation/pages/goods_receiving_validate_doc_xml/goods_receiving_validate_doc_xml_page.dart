import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/features/process_authorization/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/process_authorization/presentation/pages/goods_receiving_validate_doc_xml/components/components.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
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
    final uiController = gRValidateDocXmlUiControllerProvider(processCode);

    return BaseScaffold(
      isScrollable: false,
      refreshProvider: provider,
      usePadding: false,
      appBar: BaseAppBar(title: 'Diferenças de XML'.hardcoded),
      bottomNavigationBar: Consumer(
        builder: (_, ref, _) {
          final currentIndex = ref.watch(
            uiController.select((s) => s.selectedPageIndex),
          );
          return BaseBottomNavigationBar(
            items: [
              BaseBottomNavigationBarItem(
                platformIcon: const PlatformIcon(
                  cupertinoIcon: CupertinoIcons.doc,
                  materialIcon: Icons.list,
                ),
                label: 'Não julgados'.hardcoded,
              ),
              BaseBottomNavigationBarItem(
                platformIcon: const PlatformIcon(
                  cupertinoIcon: CupertinoIcons.doc_checkmark,
                  materialIcon: Icons.check_box,
                ),
                label: 'Julgados'.hardcoded,
              ),
            ],
            currentIndex: currentIndex,
            onTap: ref.read(uiController.notifier).updatePageIndex,
          );
        },
      ),
      body: AsyncValueWidget(
        value: ref.watch(provider),
        tryAgain: () => ref.invalidate(provider),
        data: (data) {
          return IndexedStack(
            index: ref.watch(uiController.select((s) => s.selectedPageIndex)),
            children: [
              GoodsReceivingValidateDocXmlProductsTable(
                areJudgedItems: false,
                processCode: processCode,
              ),
              GoodsReceivingValidateDocXmlProductsTable(
                areJudgedItems: true,
                processCode: processCode,
              ),
            ],
          );
        },
      ),
    );
  }
}
