import 'package:flutter/material.dart';

import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:celta_inventario/features/enterprise_manager/domain/entities/entities.dart';
import 'package:celta_inventario/features/enterprise_manager/presentation/pages/enterprise_manager/enterprises/components/components.dart';

class FilteredEnterprises extends StatefulWidget {
  final List<EnterprisePermissionEntity> enterprises;
  final TextEditingController filterController;
  const FilteredEnterprises({
    super.key,
    required this.enterprises,
    required this.filterController,
  });

  @override
  State<FilteredEnterprises> createState() => _FilteredEnterprisesState();
}

class _FilteredEnterprisesState extends State<FilteredEnterprises> {
  @override
  void initState() {
    super.initState();

    widget.filterController.addListener(listener);
  }

  void listener() {
    setState(() {});
  }

  @override
  void dispose() {
    widget.filterController.removeListener(listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final filteredEnterprises = (widget.enterprises.where((e) {
      return e.name.toLowerCase().removeWhiteSpaces().contains(
        widget.filterController.text.toLowerCase().removeWhiteSpaces(),
      );
    }).toList())..sort((a, b) => a.name.compareTo(b.name));

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        childCount: filteredEnterprises.length,
        (context, index) {
          final enterprise = filteredEnterprises[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: Sizes.p8),
            child: ExpansionTile(
              tilePadding: const EdgeInsets.symmetric(horizontal: Sizes.p4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Sizes.p12),
              ),
              collapsedShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Sizes.p12),
              ),
              backgroundColor: theme.primaryColorLight.withAlpha(30),
              collapsedBackgroundColor: theme.primaryColorDark.withAlpha(30),
              // tilePadding: const EdgeInsets.all(Sizes.p4),
              childrenPadding: EdgeInsets.only(
                bottom: index + 1 == filteredEnterprises.length ? Sizes.p8 : 0,
              ),
              iconColor: theme.primaryColorDark,
              collapsedIconColor: theme.primaryColor,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            text: enterprise.name.toUpperCase(),
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: theme.primaryColorDark,
                            ),
                            children: [
                              TextSpan(
                                text: ' (${enterprise.subEnterprises.length})',
                                style: theme.textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ),
                      EditEnterpriseButton(enterprise: enterprise),
                    ],
                  ),
                ],
              ),
              subtitle: Wrap(
                children: enterprise.globalModules
                    .where((e) => e.isEnabled == true)
                    .map((e) {
                      return Text(
                        "${e.name}; ",
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.green,
                        ),
                      );
                    })
                    .toList(),
              ),
              children: [SubEnterprises(enterprise: enterprise)],
            ),
          );
        },
      ),
    );
  }
}
