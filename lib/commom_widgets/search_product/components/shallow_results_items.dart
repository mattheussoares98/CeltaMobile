import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/products/products.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ShallowResultsItems extends ConsumerWidget {
  final Function(ProductEntity) onSelected;

  const ShallowResultsItems({super.key, required this.onSelected});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final packingStyle = context.theme.textTheme.titleSmall?.copyWith(
      color: context.theme.colorScheme.secondary,
    );
    final titleStyle = context.theme.textTheme.bodyMedium;
    final pluStyle = context.theme.textTheme.titleSmall;

    final keyboardHeight = MediaQuery.viewInsetsOf(context).bottom;
    final screenHeight = MediaQuery.sizeOf(context).height;
    final maxAllowedHeight = screenHeight - keyboardHeight - 220;

    return RepaintBoundary(
      child: Material(
        elevation: 5,
        shadowColor: Colors.black,
        borderRadius: BorderRadius.circular(Sizes.p8),
        child: Container(
          constraints: BoxConstraints(
            maxHeight: maxAllowedHeight > 120 ? maxAllowedHeight : 120,
          ),
          child: _Items(
            onSelected: onSelected,
            packingStyle: packingStyle,
            titleStyle: titleStyle,
            pluStyle: pluStyle,
          ),
        ),
      ),
    );
  }
}

class _Items extends ConsumerWidget {
  final TextStyle? packingStyle;
  final TextStyle? titleStyle;
  final TextStyle? pluStyle;

  const _Items({
    required this.onSelected,
    required this.packingStyle,
    required this.titleStyle,
    required this.pluStyle,
  });

  final Function(ProductEntity) onSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(
      shallowProductsStateControllerProvider.select((s) => s.value),
    );

    if (products?.isEmpty == true) {
      return const _EmptyResult();
    }

    return ListView.separated(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const ClampingScrollPhysics(),
      itemCount: products?.length ?? 0,
      separatorBuilder: (_, _) => const Divider(height: 0),
      itemBuilder: (context, index) {
        final product = products![index];

        return _ShallowItemTile(
          key: ValueKey(product.codigoInternoProEmb),
          product: product,
          onTap: () => onSelected(product),
          packingStyle: packingStyle,
          titleStyle: titleStyle,
          pluStyle: pluStyle,
        );
      },
    );
  }
}

class _EmptyResult extends StatelessWidget {
  const _EmptyResult();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(Sizes.p16),
        child: BaseText(context.l10n.noProducts),
      ),
    );
  }
}

class _ShallowItemTile extends StatelessWidget {
  final VoidCallback onTap;
  final ProductEntity product;
  final TextStyle? packingStyle;
  final TextStyle? titleStyle;
  final TextStyle? pluStyle;

  const _ShallowItemTile({
    required this.onTap,
    required this.packingStyle,
    required this.titleStyle,
    required this.pluStyle,
    required this.product,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: Sizes.p4,
          horizontal: Sizes.p16,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TitleAndSubTitle(
                    title: product.Name,
                    subTitle: product.formattedPacking,
                    titleStyle: titleStyle,
                    subTitleStyle: packingStyle,
                    removeColon: true,
                  ),
                  TitleAndSubTitle(
                    title: null,
                    subTitle: product.PLU,
                    subTitleStyle: pluStyle,
                  ),
                ],
              ),
            ),
            const _SearchIcon(),
          ],
        ),
      ),
    );
  }
}

class _SearchIcon extends StatelessWidget {
  const _SearchIcon();
  @override
  Widget build(BuildContext context) {
    return PlatformIcon(
      cupertinoIcon: CupertinoIcons.search,
      materialIcon: Icons.search,
      color: context.theme.disabledColor,
      size: 20,
    );
  }
}
