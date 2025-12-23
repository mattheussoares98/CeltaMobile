import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../../../../core/domain/entities/entities.dart';
import '../../../controllers/controllers.dart';

class SelectProductModalPage extends ConsumerWidget {
  final AsyncValue<List<ProductEntity>> n;
  final int expeditionControlCode;
  final int stepCode;
  const SelectProductModalPage({
    super.key,
    required this.n,
    required this.expeditionControlCode,
    required this.stepCode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(Sizes.p8),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Text(
              'Selecione o produto que deseja confirmar'.hardcoded,
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
          ),
          SliverList.builder(
            itemCount: n.value!.length,
            itemBuilder: (_, index) {
              final product = n.value![index];
              return Card(
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

                    if (succeeds) {
                      context.pop();
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(Sizes.p8),
                    child: Column(
                      children: [
                        TitleAndSubTitle(title: null, subTitle: product.Name),
                        TitleAndSubTitle(
                          title: 'PLU'.hardcoded,
                          subTitle: product.PLU,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
