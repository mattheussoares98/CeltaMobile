import 'package:celta_inventario/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:celta_inventario/utils/utils.dart';

class ActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget icon;
  final Color color;
  final VoidCallback onTap;

  const ActionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(Sizes.p16),
        child: Container(
          padding: const EdgeInsets.all(Sizes.p16),
          decoration: BoxDecoration(
            border: Border.all(color: context.theme.dividerColor.withAlpha(40)),
            borderRadius: BorderRadius.circular(Sizes.p16),
          ),
          child: Row(
            children: [
              if (screenWidth > 300) ...[
                Container(
                  padding: const EdgeInsets.all(Sizes.p12),
                  decoration: BoxDecoration(
                    color: color.withAlpha(20),
                    shape: BoxShape.circle,
                  ),
                  child: icon,
                ),
                gapW16,
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: context.theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: context.theme.textTheme.bodySmall?.copyWith(
                        color: context.theme.hintColor,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: context.theme.dividerColor),
            ],
          ),
        ),
      ),
    );
  }
}
