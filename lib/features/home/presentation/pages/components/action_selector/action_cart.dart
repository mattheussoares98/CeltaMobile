import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/home/presentation/model/model.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';

class ActionCard extends StatelessWidget {
  final PageActionSelectorModel actionModel;

  const ActionCard({super.key, required this.actionModel});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => Navigator.pop(context, actionModel.route),
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
                    color: actionModel.color.withAlpha(20),
                    shape: BoxShape.circle,
                  ),
                  child: actionModel.platformIcon,
                ),
                gapW16,
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      actionModel.title,
                      style: context.theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      actionModel.subtitle,
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
