import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../domain/entities/entities.dart';

class CountingsItems extends StatelessWidget {
  final List<CountingEntity>? countings;
  const CountingsItems({super.key, required this.countings});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      //TODO add RefreshIndicator
      itemCount: countings?.length ?? 0,
      itemBuilder: (_, index) {
        final counting = countings![index];
        return Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
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
        );
      },
    );
  }
}
