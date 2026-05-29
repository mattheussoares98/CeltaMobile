import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/expedition_conference/presentation/controllers/controllers.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SelectProductModalPage extends ConsumerWidget {
  final List<ProductEntity> products;
  final int expeditionControlCode;
  final int stepCode;
  const SelectProductModalPage({
    super.key,
    required this.products,
    required this.expeditionControlCode,
    required this.stepCode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(Sizes.p8),
      child: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Text(
              'Selecione o produto que deseja confirmar'.hardcoded,
              style: context.theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
          ),
          SliverList.builder(
            itemCount: products.length,
            itemBuilder: (_, index) {
              final product = products[index];
              return _ProductItem(
                key: ValueKey(product.ProductPackingCode),
                product: product,
                expeditionControlCode: expeditionControlCode,
                stepCode: stepCode,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ProductItem extends ConsumerWidget {
  final ProductEntity product;
  final int expeditionControlCode;
  final int stepCode;
  const _ProductItem({
    super.key,
    required this.product,
    required this.expeditionControlCode,
    required this.stepCode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RepaintBoundary(
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () async {
            final succeeds = await ref
                .read(scanProductControllerProvider.notifier)
                .scan(
                  expeditionControlCode: expeditionControlCode,
                  productPackingCode: product.ProductPackingCode!,
                  stepCode: stepCode,
                );

            if (succeeds && context.mounted) {
              context.pop();
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(Sizes.p8),
            child: Column(
              children: [
                TitleAndSubTitle(title: null, subTitle: product.Name),
                TitleAndSubTitle(title: 'PLU'.hardcoded, subTitle: product.PLU),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
