import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../core/domain/entities/entities.dart';
import '../address.dart';

class StatesDropDown extends StatelessWidget {
  const StatesDropDown({
    super.key,
    required this.isLoading,
    required this.page,
  });

  final bool isLoading;
  final AddressPage page;

  @override
  Widget build(BuildContext context) {
    return DefaultSimpleDropDown<BrazilStates?>(
      isLoading: isLoading,
      onChanged: null,
      items: BrazilStates.values
          .map(
            (e) => DropdownMenuItem(
              value: e,
              onTap: () => page.onChangeState(e),
              child: Center(child: Text(e.name)),
            ),
          )
          .toList(),
      value: page.state,
      hint: 'Estado'.hardcoded,
    );
  }
}
