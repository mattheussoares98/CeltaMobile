import 'package:flutter/material.dart';

import '../../../../../../constants/constants.dart';
import '../../../../domain/entities/entities.dart';
import 'components.dart';

class FilteredEnterprises extends StatefulWidget {
  final List<EnterprisePermissionEntity> enterprises;
  final TextEditingController filterEnterpriseNameController;
  const FilteredEnterprises({
    super.key,
    required this.enterprises,
    required this.filterEnterpriseNameController,
  });

  @override
  State<FilteredEnterprises> createState() => _FilteredEnterprisesState();
}

class _FilteredEnterprisesState extends State<FilteredEnterprises> {
  @override
  void initState() {
    super.initState();

    widget.filterEnterpriseNameController.addListener(listener);
  }

  void listener() {
    setState(() {});
  }

  @override
  void dispose() {
    widget.filterEnterpriseNameController.removeListener(listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final filteredEnterprises = (widget.enterprises.where((e) {
      return e.name.toLowerCase().contains(
        widget.filterEnterpriseNameController.text.toLowerCase(),
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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Sizes.p12),
              ),
              collapsedShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Sizes.p12),
              ),
              backgroundColor: theme.primaryColorLight.withAlpha(120),
              collapsedBackgroundColor: theme.primaryColorLight.withAlpha(60),
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
