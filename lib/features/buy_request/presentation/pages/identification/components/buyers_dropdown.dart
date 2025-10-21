import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../../domain/entities/entities.dart';
import '../../../controllers/controllers.dart';
import '../../components/components.dart';

class BuyersDropdown extends ConsumerWidget {
  final AsyncValue<List<BuyerEntity>?> buyersState;
  const BuyersDropdown({super.key, required this.buyersState});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AsyncValueWidget(
      value: buyersState,
      tryAgain: () {
        ref.invalidate(buyersStateControllerProvider);
      },
      data: (buyers) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DefaultSmallTitle(title: 'Comprador'.hardcoded),
            gapH4,
            DefaultDropDown<BuyerEntity>(
              onChanged: (buyer) {
                //TODO change selectedBuyer
              },
              items: buyers
                  ?.map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Center(child: Text(e.Name)),
                    ),
                  )
                  .toList(),
              selectedItem: null, //TODO add selectedBuyer
              hint: Text('Selecionar'.hardcoded),
              label: 'Comprador'.hardcoded,
            ),
          ],
        );
      },
    );
  }
}
