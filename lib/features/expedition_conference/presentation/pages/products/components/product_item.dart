import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../../../../localization/string_hardcoded.dart';
import '../../../../../../utils/utils.dart';
import '../../../controllers/controllers.dart';

class ProductItem extends ConsumerWidget {
  final int index;
  final int expeditionControlCode;
  final bool isPending;
  const ProductItem({
    super.key,
    required this.index,
    required this.expeditionControlCode,
    required this.isPending,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final product = ref.watch(
      expeditionConferenceControllerProvider(expeditionControlCode).select(
        (s) => isPending
            ? s.value!.pendingProducts[index]
            : s.value!.scannedProducts[index],
      ),
    );

    return RepaintBoundary(
      child: Card(
        margin: const EdgeInsets.only(top: Sizes.p8),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.all(Sizes.p8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TitleAndSubTitle(title: null, subTitle: product.Name),
              TitleAndSubTitle(
                title: 'PLU'.hardcoded,
                subTitle: product.PriceLookUp,
              ),
              TitleAndSubTitle(
                title: 'Quantidade'.hardcoded,
                subTitle: product.Quantity.toString().toBrazilianNumber(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
