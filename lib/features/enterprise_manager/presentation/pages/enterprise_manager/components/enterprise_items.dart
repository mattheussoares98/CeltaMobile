import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../constants/constants.dart';
import '../../../../../../core/presentation/theme/theme.dart';
import '../../../../domain/entities/entities.dart';
import 'components.dart';

class EnterpriseItems extends ConsumerStatefulWidget {
  final List<EnterprisePermissionEntity> enterprises;
  final TextEditingController filterEnterpriseNameController;
  const EnterpriseItems({
    super.key,
    required this.enterprises,
    required this.filterEnterpriseNameController,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EnterpriseItemsState();
}

class _EnterpriseItemsState extends ConsumerState<EnterpriseItems> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final filteredEnterprises = (widget.enterprises.where((e) {
      return e.name.toLowerCase().contains(
        widget.filterEnterpriseNameController.text.toLowerCase(),
      );
    }).toList())..sort((a, b) => a.name.compareTo(b.name));

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(Sizes.p8),
            child: TextFormField(
              controller: widget.filterEnterpriseNameController,
              onChanged: (_) {
                setState(() {});
              },
              decoration: AppDecorations.input(
                context: context,
                hintText: "Filtrar empresa",
                labelText: 'Filtrar empresa',
              ),
            ),
          ),
        ),
        SliverList(
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
                  collapsedBackgroundColor: theme.primaryColorLight.withAlpha(
                    60,
                  ),
                  // tilePadding: const EdgeInsets.all(Sizes.p4),
                  childrenPadding: EdgeInsets.only(
                    bottom: index + 1 == filteredEnterprises.length
                        ? Sizes.p8
                        : 0,
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
                                    text:
                                        ' (${enterprise.subEnterprises.length})',
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
        ),
      ],
    );
  }
}
