import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/features/process_authorization/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/process_authorization/presentation/pages/goods_receiving_validate_doc_xml/components/components.dart';
import 'package:celta_inventario/features/receipt/domain/entity/entity.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GoodsReceivingValidateDocXmlPage extends ConsumerStatefulWidget {
  final int processCode;
  const GoodsReceivingValidateDocXmlPage({
    super.key,
    required this.processCode,
  });

  @override
  ConsumerState<GoodsReceivingValidateDocXmlPage> createState() =>
      _GoodsReceivingValidateDocXmlPageState();
}

class _GoodsReceivingValidateDocXmlPageState
    extends ConsumerState<GoodsReceivingValidateDocXmlPage> {
  final ValueNotifier<Set<int>> _selectedProductsNotifier =
      ValueNotifier<Set<int>>({});

  @override
  void dispose() {
    _selectedProductsNotifier.dispose();
    super.dispose();
  }

  void _toggleProductSelection(BSFGoodsReceivingProductEntity item) {
    final selectedProducts = Set<int>.from(_selectedProductsNotifier.value);
    if (!selectedProducts.add(item.code)) {
      selectedProducts.remove(item.code);
    }
    _selectedProductsNotifier.value = selectedProducts;
  }

  @override
  Widget build(BuildContext context) {
    final provider = gRDocFiscalNoteDifferencesStateControllerProvider(
      widget.processCode,
    );
    return BaseScaffold(
      isScrollable: false,
      refreshProvider: provider,
      usePadding: false,
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

          return GoodsReceivingValidateDocXmlProductsTable(
            refreshProvider: provider,
            items: data.products!,
            selectedProductsNotifier: _selectedProductsNotifier,
            onTapProduct: _toggleProductSelection,
          );
        },
      ),
    );
  }
}
