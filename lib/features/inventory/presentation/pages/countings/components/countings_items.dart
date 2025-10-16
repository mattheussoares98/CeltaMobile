import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../../../../routing/routing.dart';
import '../../../../domain/entities/entities.dart';

class CountingsItems extends StatelessWidget {
  final List<CountingEntity>? countings;
  final int enterpriseCode;
  const CountingsItems({
    super.key,
    required this.countings,
    required this.enterpriseCode,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      //TODO add RefreshIndicator
      itemCount: countings?.length ?? 0,
      itemBuilder: (_, index) {
        final counting = countings![index];
        return Card(
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () {
              context.pushNamed(
                Routes.inventoryProducts.name,
                pathParameters: {
                  'codigoInternoInvCont':
                      counting.CodigoInternoInvCont.toString(),
                  'enterpriseCode': enterpriseCode.toString(),
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
        );
      },
    );
  }
}
