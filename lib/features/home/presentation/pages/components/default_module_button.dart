import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../../../../core/domain/entities/entities.dart';
import '../../../../../core/presentation/controllers/enterprises/enterprises.dart';
import '../../../../../core/presentation/controllers/user_session/user_session.dart';
import '../../../../../routing/routing.dart';
import '../../../../enterprises/presentation/controllers/controllers.dart';
import '../../controllers/controllers.dart';

class DefaultModuleButton extends ConsumerWidget {
  final Routes route;
  final Modules module;
  final IconData cupertinoIcon;
  final IconData materialIcon;
  final bool passEnterpriseToNextRoute;

  const DefaultModuleButton({
    super.key,
    required this.route,
    required this.module,
    required this.cupertinoIcon,
    required this.materialIcon,
    this.passEnterpriseToNextRoute = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedEnterprise = ref.watch(
      selectedEnterpriseStateControllerProvider,
    );
    //TODO show dialog if try to access adjustSalePrice and the user doesnt has permission
    void showDisabledModuleMessage() {
      showAlertDialog(
        context: context,
        title: 'Módulo desabilitado'.hardcoded,
        content:
            'O módulo ${route.module.toUpperCase()} está desabilitado para essa empresa. Caso queira habilitar, entre em contato com o setor administrativo'
                .hardcoded,
      );
    }

    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;
    final isFavorite = ref.watch(
      favoriteModulesStateControllerProvider.select(
        (s) => s.value?.any((x) => x == module) ?? false,
      ),
    );

    return InkWell(
      child: Stack(
        children: [
          Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              border: Border.all(color: theme.primaryColor, width: 0.4),
              borderRadius: BorderRadius.circular(Sizes.p12),
            ),
            child: Consumer(
              builder: (_, ref, _) {
                final enterpriseName = ref.watch(
                  validatedUserSessionProvider.select(
                    (s) => s.value!.enterprise!.name,
                  ),
                );
                final enabledModulesByEnterpriseAsync = ref.watch(
                  enabledModulesByEnterpriseNameStateControllerProvider(
                    enterpriseName,
                  ),
                );

                return InkWell(
                  onTap: selectedEnterprise == null
                      ? null
                      : () {
                          final correspondentEnterprise =
                              enabledModulesByEnterpriseAsync.value
                                  ?.firstWhereOrNull(
                                    (e) =>
                                        e.cnpjNumber ==
                                        selectedEnterprise.CnpjNumber,
                                  );
                          if (correspondentEnterprise == null) {
                            showDisabledModuleMessage();
                            return;
                          }

                          final enabledModules =
                              correspondentEnterprise.enabledModules;

                          bool moduleIsEnabled = enabledModules.contains(
                            module,
                          );

                          if (!moduleIsEnabled) {
                            showDisabledModuleMessage();
                            return;
                          }

                          context.goNamed(
                            route.name,
                            pathParameters: passEnterpriseToNextRoute
                                ? {
                                    'enterpriseCode':
                                        selectedEnterprise.Code.toString(),
                                  }
                                : {},
                          );
                        },
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Using a circular container with a subtle background instead of a full image card
                        Container(
                          padding: const EdgeInsets.all(Sizes.p8),
                          decoration: BoxDecoration(
                            color: theme.primaryColor.withAlpha(50),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isIOS ? cupertinoIcon : materialIcon,
                            color: theme.primaryColor,
                          ),
                        ),
                        const SizedBox(height: Sizes.p12),
                        Text(
                          route.module,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              onPressed: () => ref
                  .read(favoriteModulesStateControllerProvider.notifier)
                  .toggle(module),
              icon: isFavorite
                  ? Icon(
                      isIOS ? CupertinoIcons.star_fill : Icons.star,
                      color: theme.primaryColorDark,
                      size: 14,
                    )
                  : Icon(
                      isIOS ? CupertinoIcons.star : Icons.star_border,
                      color: theme.disabledColor,
                      size: 14,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
