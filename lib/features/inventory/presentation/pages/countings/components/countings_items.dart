import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../../../../routing/routing.dart';
import '../../../../domain/entities/entities.dart';

class CountingsItems extends ConsumerWidget {
  final List<CountingEntity>? countings;
  final int enterpriseCode;
  final int codigoInternoInventario;
  const CountingsItems({
    super.key,
    required this.countings,
    required this.enterpriseCode,
    required this.codigoInternoInventario,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
      itemCount: countings?.length ?? 0,
      itemBuilder: (_, index) {
        final counting = countings![index];
        return _CountingItem(
          key: ValueKey(counting.CodigoInternoInvCont),
          counting: counting,
          enterpriseCode: enterpriseCode,
          codigoInternoInventario: codigoInternoInventario,
        );
      },
    );
  }
}

class _CountingItem extends StatelessWidget {
  final CountingEntity counting;
  final int enterpriseCode;
  final int codigoInternoInventario;
  const _CountingItem({
    super.key,
    required this.counting,
    required this.enterpriseCode,
    required this.codigoInternoInventario,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            context.pushNamed(
              Routes.inventoryProducts.name,
              pathParameters: {
                'codigoInternoInvCont':
                    counting.CodigoInternoInvCont.toString(),
                'enterpriseCode': enterpriseCode.toString(),
                'codigoInternoInventario': codigoInternoInventario.toString(),
              },
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(Sizes.p8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TitleAndSubTitle(
                  title: 'Número'.hardcoded,
                  subTitle: counting.NumeroContagemInvCont.toString(),
                ),
                if (counting.ObsInvCont != null)
                  TitleAndSubTitle(
                    title: 'Obs'.hardcoded,
                    subTitle: counting.ObsInvCont,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
