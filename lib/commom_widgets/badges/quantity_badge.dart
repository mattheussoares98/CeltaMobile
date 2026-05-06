import 'package:flutter/material.dart';

import '../../utils/utils.dart';
import '../commom_widgets.dart';

class QuantityBadge extends StatefulWidget {
  final int? quantity;
  final PlatformIcon platformIcon;
  final bool isSelected;
  final double? totalPrice;
  const QuantityBadge({
    super.key,
    required this.quantity,
    required this.platformIcon,
    required this.isSelected,
    this.totalPrice,
  });

  @override
  State<QuantityBadge> createState() => _QuantityBadgeState();
}

class _QuantityBadgeState extends State<QuantityBadge>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.3), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.3, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void didUpdateWidget(covariant QuantityBadge oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.quantity != widget.quantity) {
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    bool isSmall = (widget.quantity?.toString() ?? '0').length <= 1;
    return RepaintBoundary(
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Badge(
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
                child: FittedBox(
                  child: Text(widget.quantity?.toString() ?? '0'),
                ),
              ),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              PlatformIcon(
                cupertinoIcon: widget.platformIcon.cupertinoIcon,
                materialIcon: widget.platformIcon.materialIcon,
                color: widget.isSelected
                    ? theme.primaryColor
                    : theme.disabledColor,
              ),
              if (widget.totalPrice != null)
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'R\$ ',
                        style: theme.textTheme.bodySmall?.copyWith(fontSize: 9),
                      ),
                      TextSpan(
                        text: widget.totalPrice.toString().toBrazilianNumber(),
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
