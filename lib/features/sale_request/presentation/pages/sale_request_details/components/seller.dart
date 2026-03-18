import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../../../../localization/string_hardcoded.dart';
import '../../../controllers/controllers.dart';

class Seller extends ConsumerWidget {
  final int saleRequestId;
  const Seller({super.key, required this.saleRequestId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final seller = ref.watch(
      saleRequestDetailsStateControllerProvider(
        saleRequestId,
      ).select((s) => s.value?.collection.first.Seller),
    );

    if (seller == null) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    return SliverToBoxAdapter(
      child: Card(
        child: Padding(
          padding: const EdgeInsetsGeometry.all(Sizes.p8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TitleAndSubTitle(
                title: 'Vendedor'.hardcoded,
                subTitle: seller.Name,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
