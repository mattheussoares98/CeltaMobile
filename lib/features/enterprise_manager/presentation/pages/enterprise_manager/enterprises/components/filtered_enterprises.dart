import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/enterprise_manager/domain/entities/entities.dart';
import 'package:celta_inventario/features/enterprise_manager/presentation/pages/enterprise_manager/enterprises/components/components.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';

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
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            text: enterprise.name.toUpperCase(),
                            style: context.theme.textTheme.titleLarge?.copyWith(
                              color: context.theme.primaryColorDark,
                            ),
                            children: [
                              TextSpan(
                                text: ' (${enterprise.subEnterprises.length})',
                                style: context.theme.textTheme.bodySmall,
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
                      return BaseText.bodySmall(
                        "${e.name}; ",
                        color: Colors.green,
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
