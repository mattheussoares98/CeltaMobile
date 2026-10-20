import 'package:celta_inventario/utils/utils.dart';
import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:flutter/material.dart';

class StatesDropDown extends StatelessWidget {
  const StatesDropDown({
    super.key,
    required this.isLoading,
    required this.state,
    required this.onChangeState,
  });

  final bool isLoading;
  final BrazilStates? state;
  final void Function(BrazilStates? state) onChangeState;

  @override
  Widget build(BuildContext context) {
    return BaseDropDown<BrazilStates?>(
      onChanged: null,
      items: BrazilStates.values
          .map(
            (e) => DropdownMenuItem(
              value: e,
              onTap: () => onChangeState(e),
              child: Center(child: Text(e.name)),
            ),
          )
          .toList(),
      selectedItem: state,
      label: context.l10n.state,
      isSimple: true,
    );
  }
}
