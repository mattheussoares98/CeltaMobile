import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../constants/constants.dart';
import '../../../../domain/entities/entities.dart';

class EnterpriseItems extends ConsumerWidget {
  final List<EnterprisePermissionEntity> enterprises;
  const EnterpriseItems({super.key, required this.enterprises});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return ListView.builder(
      padding: EdgeInsets.all(Sizes.p4),
      itemCount: enterprises.length,
      itemBuilder: (context, index) {
        final enterprise = enterprises[index];
        return ExpansionTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Sizes.p12),
          ),
          collapsedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Sizes.p12),
          ),
          backgroundColor: theme.primaryColorLight.withAlpha(120),
          collapsedBackgroundColor: Colors.transparent,
          tilePadding: const EdgeInsets.all(Sizes.p4),
          childrenPadding: EdgeInsets.only(
            bottom: index + 1 == enterprises.length ? Sizes.p8 : 0,
          ),
          iconColor: theme.primaryColorDark,
          collapsedIconColor: theme.primaryColor,
          title: Text(
            enterprise.name,
            //TODO below this name, show modules that are globally enabled
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.primaryColorDark,
            ),
          ),
          children: enterprise.subEnterprises.map((e) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: Sizes.p8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  RichText(
                    textAlign: TextAlign.start,
                    text: TextSpan(
                      style: theme.textTheme.bodyMedium,
                      children: [
                        TextSpan(
                          text: '${e.personalizedCode} - ${e.name}',
                          style: theme.textTheme.titleMedium,
                        ),
                        TextSpan(text: ' (${e.cnpjNumber})'),
                        //TODO below here, add modules that are defined at cnpj level
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
