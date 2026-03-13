import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../../../../core/presentation/controllers/products/products.dart';
import '../../../../../../localization/string_hardcoded.dart';
import '../../../core/domain/entities/entities.dart';

class ShallowResultsItems extends ConsumerWidget {
  final Function(ProductEntity) onSelected;

  const ShallowResultsItems({super.key, required this.onSelected});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final packingStyle = theme.textTheme.titleSmall?.copyWith(
      color: theme.colorScheme.secondary,
    );
    final titleStyle = theme.textTheme.bodyMedium;
    final pluStyle = theme.textTheme.titleSmall;

    final keyboardHeight = MediaQuery.viewInsetsOf(context).bottom;
    final screenHeight = MediaQuery.sizeOf(context).height;
    final maxAllowedHeight = screenHeight - keyboardHeight - 220;

    return RepaintBoundary(
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(Sizes.p8),
        clipBehavior: Clip.none, // PERFORMANCE: Clip.none is faster on GPU
        child: Container(
          constraints: BoxConstraints(
            maxHeight: maxAllowedHeight > 120 ? maxAllowedHeight : 120,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Sizes.p8),
            border: Border.all(color: theme.dividerColor.withAlpha(50)),
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
    return AsyncValueWidget(
      useLinearProgressIndicator: true,
      value: ref.watch(shallowProductsStateControllerProvider),
      tryAgain: null,
      data: (products) {
        if (products == null) {
          return const SizedBox.shrink();
        }
        if (products.isEmpty) {
          return const _EmptyResult();
        }

        return SingleChildScrollView(
          child: RepaintBoundary(
            child: Column(
              children: products.map((product) {
                return _ShallowItemTile(
                  product: product,
                  onTap: (product) => onSelected(product),
                  packingStyle: packingStyle,
                  titleStyle: titleStyle,
                  pluStyle: pluStyle,
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}

class _EmptyResult extends StatelessWidget {
  const _EmptyResult();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Sizes.p16),
      child: Text('Nenhum produto'.hardcoded),
    );
  }
}

class _ShallowItemTile extends StatelessWidget {
  final Function(ProductEntity) onTap;
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
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(product),
      child: Container(
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black12)),
        ),
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
      ),
    );
  }
}

class _SearchIcon extends StatelessWidget {
  const _SearchIcon();
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Icon(
      theme.platform == TargetPlatform.iOS
          ? CupertinoIcons.search
          : Icons.search,
      color: theme.disabledColor,
      size: 20,
    );
  }
}
