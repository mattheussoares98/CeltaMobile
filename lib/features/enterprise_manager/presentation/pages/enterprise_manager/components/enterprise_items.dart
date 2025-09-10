import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../constants/constants.dart';
import '../../../../../../routing/routing.dart';
import '../../../../domain/entities/entities.dart';
import 'components.dart';

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
          collapsedBackgroundColor: theme.primaryColorLight.withAlpha(60),
          tilePadding: const EdgeInsets.all(Sizes.p4),
          childrenPadding: EdgeInsets.only(
            bottom: index + 1 == enterprises.length ? Sizes.p8 : 0,
          ),
          iconColor: theme.primaryColorDark,
          collapsedIconColor: theme.primaryColor,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      enterprise.name,
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: theme.primaryColorDark,
                      ),
                    ),
                  ),
                  EditEnterpriseButton(enterprise: enterprise),
                ],
              ),
              Wrap(
                children: enterprise.globalModules
                    .where((e) => e.isEnabled == true)
                    .map((e) {
                      return Text(
                        e.name,
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: Colors.green,
                        ),
                      );
                    })
                    .toList(),
              ),
            ],
          ),
          children: enterprise.subEnterprises.map((e) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: Sizes.p8),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                            ],
                          ),
                        ),
                        for (var module in e.modules.where(
                          (x) => x.isDefinedAtCnpjLevel,
                        ))
                          Text(
                            module.name,
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: module.isEnabled ?? false
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      context.pushNamed(
                        AppRoute.enterpriseManagerChangeModulesPermissions.name,
                        pathParameters: {
                          'enterpriseId': enterprise.id.toString(),
                          'subEnterpriseId': e.id.toString(),
                        },
                      );
                    },
                    icon: Icon(
                      theme.platform == TargetPlatform.iOS
                          ? CupertinoIcons.pencil
                          : Icons.edit,
                      color: theme.primaryColorDark,
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
