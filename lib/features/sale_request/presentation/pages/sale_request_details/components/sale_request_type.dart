import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../../../../localization/string_hardcoded.dart';
import '../../../controllers/controllers.dart';

class SaleRequestType extends ConsumerWidget {
  final int saleRequestId;
  const SaleRequestType({super.key, required this.saleRequestId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requestType = ref.watch(
      saleRequestDetailsStateControllerProvider(
        saleRequestId,
      ).select((s) => s.value?.collection.first.RequestType),
    );

    if (requestType == null) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    return SliverToBoxAdapter(
      child: Card(
        child: Padding(
          padding: const EdgeInsetsGeometry.all(Sizes.p8),
          child: TitleAndSubTitle(
            title: 'Modelo de pedido'.hardcoded,
            copyableSubtitle: true,
            subTitle: requestType.Name,
          ),
        ),
      ),
    );
  }
}
