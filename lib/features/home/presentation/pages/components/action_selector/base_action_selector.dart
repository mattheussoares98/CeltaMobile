import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/home/presentation/model/model.dart';
import 'package:celta_inventario/features/home/presentation/pages/components/action_selector/action_selector.dart';
import 'package:celta_inventario/routing/routing.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';

class BaseActionSelector {
  BaseActionSelector._();

  static Future<Routes?> show(
    BuildContext context, {
    required List<PageActionSelectorModel> actions,
    required String title,
  }) async {
    return await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _BaseActionSelector(actions: actions, title: title),
    );
  }
}

class _BaseActionSelector extends StatelessWidget {
  final List<PageActionSelectorModel> actions;
  final String title;
  const _BaseActionSelector({required this.actions, required this.title});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          Sizes.p16,
          Sizes.p12,
          Sizes.p16,
          Sizes.p80,
        ),
        decoration: BoxDecoration(
          color: context.theme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(Sizes.p24),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(20),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle for visual feedback (drag indicator)
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: Sizes.p20),
                decoration: BoxDecoration(
                  color: context.theme.dividerColor.withAlpha(100),
                  borderRadius: BorderRadius.circular(Sizes.p4),
                ),
              ),
              Text(
                title,
                style: context.theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              gapH24,
              ...actions.map(
                (e) => Padding(
                  padding: const EdgeInsets.only(bottom: Sizes.p12),
                  child: ActionCard(actionModel: e),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
