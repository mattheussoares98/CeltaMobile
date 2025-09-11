import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../constants/constants.dart';
import '../../../../../../routing/routing.dart';
import '../../../../domain/entities/entities.dart';

class SubEnterprises extends StatelessWidget {
  final EnterprisePermissionEntity enterprise;
  const SubEnterprises({super.key, required this.enterprise});

  void onTap(
    BuildContext context,
    SubEnterprisePermissionEntity subEnterprise,
  ) {
    context.pushNamed(
      AppRoute.enterpriseManagerChangeModulesPermissions.name,
      pathParameters: {
        'enterpriseId': enterprise.id.toString(),
        'subEnterpriseId': subEnterprise.id.toString(),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView.separated(
      itemCount: enterprise.subEnterprises.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      separatorBuilder: (_, index) {
        return _MyDivider();
      },
      itemBuilder: (_, index) {
        final subEnterprise = enterprise.subEnterprises[index];
        return InkWell(
          onTap: () => onTap(context, subEnterprise),
          child: Column(
            children: [
              if (index == 0) _MyDivider(),
              Padding(
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
                                  text:
                                      '${subEnterprise.personalizedCode} - ${subEnterprise.name}',
                                  style: theme.textTheme.titleMedium,
                                ),
                                TextSpan(
                                  text: ' (${subEnterprise.cnpjNumber})',
                                ),
                              ],
                            ),
                          ),
                          for (var module in subEnterprise.modules.where(
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
                        onTap(context, subEnterprise);
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
              ),
            ],
          ),
        );
      },
    );
  }
}

class _MyDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(
      color: Theme.of(context).disabledColor,
      height: Sizes.p8,
      thickness: 1,
    );
  }
}
