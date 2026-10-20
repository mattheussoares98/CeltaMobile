import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/enterprise_manager/domain/entities/entities.dart';
import 'package:celta_inventario/features/enterprise_manager/presentation/controllers/controllers.dart';
import 'package:celta_inventario/routing/routing.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:celta_inventario/utils/utils.dart';

class SubEnterprises extends ConsumerWidget {
  final EnterprisePermissionEntity enterprise;
  const SubEnterprises({super.key, required this.enterprise});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void onTap(SubEnterprisePermissionEntity subEnterprise) {
      final isAdminLogin = ref.read(
        authManagerStateProvider.select(
          (s) => s.value?.email?.toLowerCase() == 'admin@celtaware.com.br',
        ),
      );
      if (isAdminLogin) {
        context.pushNamed(
          Routes.enterpriseManagerChangeModulesPermissions.name,
          pathParameters: {
            'enterpriseId': enterprise.id.toString(),
            'subEnterpriseId': subEnterprise.id.toString(),
          },
        );
      } else {
        showAlertDialog(
          context: context,
          title: context.l10n.noPermission,
          content: context.l10n.onlyAdministratorsCanMakeThisChange,
        );
      }
    }

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
          onTap: () => onTap(subEnterprise),
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
                            text: TextSpan(
                              style: context.theme.textTheme.bodyMedium,
                              children: [
                                TextSpan(
                                  text:
                                      '${subEnterprise.personalizedCode} - ${subEnterprise.name}',
                                  style: context.theme.textTheme.titleMedium,
                                ),
                                TextSpan(
                                  text: ' (${subEnterprise.cnpjNumber})',
                                ),
                              ],
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              children: [
                                for (var module in subEnterprise.modules.where(
                                  (x) => x.isDefinedAtCnpjLevel,
                                ))
                                  TextSpan(
                                    text: "${module.name}; ",
                                    style: context.theme.textTheme.bodySmall
                                        ?.copyWith(
                                          color: module.isEnabled ?? false
                                              ? Colors.green
                                              : Colors.red,
                                        ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => onTap(subEnterprise),
                      icon: PlatformIcon(
                        cupertinoIcon: CupertinoIcons.pencil,
                        materialIcon: Icons.edit,
                        color: context.theme.primaryColorDark,
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
      color: context.theme.disabledColor,
      height: Sizes.p8,
      thickness: 1,
    );
  }
}
