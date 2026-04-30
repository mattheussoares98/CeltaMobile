import 'package:flutter/material.dart';

import '../../utils/utils.dart';
import '../commom_widgets.dart';

class QuantityBadge extends StatelessWidget {
  final int? quantity;
  final IconData materialIcon;
  final IconData cupertinoIcon;
  final bool isSelected;
  final double? totalPrice;
  const QuantityBadge({
    super.key,
    required this.quantity,
    required this.materialIcon,
    required this.cupertinoIcon,
    required this.isSelected,
    this.totalPrice,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    bool isSmall = (quantity?.toString() ?? '0').length <= 1;
    return Badge(
      //! if it is on AppBar actions, show put this padding below
      //*actionsPadding: const EdgeInsets.fromLTRB(0, Sizes.p8, Sizes.p12, 0),
      backgroundColor: Colors.transparent,
      label: CircleAvatar(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        radius: isSmall ? 8 : 10,
        child: Padding(
          padding: EdgeInsets.all(isSmall ? 1 : 2),
          child: Center(
            child: FittedBox(child: Text(quantity?.toString() ?? '0')),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          PlatformIcon(
            cupertinoIcon: cupertinoIcon,
            materialIcon: materialIcon,
            color: isSelected ? theme.primaryColor : theme.disabledColor,
          ),
          if (totalPrice != null)
            Expanded(
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'R\$ ',
                      style: theme.textTheme.bodySmall?.copyWith(fontSize: 9),
                    ),
                    TextSpan(
                      text: totalPrice.toString().toBrazilianNumber(),
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
