import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../../../../core/domain/entities/entities.dart';
import '../../../../../../core/presentation/controllers/resource/resource.dart';
import '../../../../../../core/presentation/helpers/helpers.dart';
import '../../../../../../routing/routing.dart';
import '../../../../../enterprises/presentation/controllers/controllers.dart';
import '../components.dart';

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
    final theme = Theme.of(context);

    final isIOS = theme.platform == TargetPlatform.iOS;
    final icon = isIOS ? cupertinoIcon : materialIcon;

    void accessModule() async {
      Routes? saleRequestNextRoute;
      if (route == Routes.saleRequestActionSelector) {
        saleRequestNextRoute = await SaleRequestActionSelector.show(context);
        if (saleRequestNextRoute == null) return;
      }
      final enterpriseCode = ref.read(
        selectedEnterpriseStateControllerProvider.select((s) => s?.Code),
      );

      ref
          .read(tryAccessModuleControllerProvider.notifier)
          .tryAccess(
            context: context,
            module: module,
            route: saleRequestNextRoute ?? route,
            enterpriseCode: enterpriseCode,
            replace: true,
            pathParameters: passEnterpriseToNextRoute
                ? {'enterpriseCode': enterpriseCode.toString()}
                : null,
          );
    }

    return Material(
      color: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Sizes.p12),
        side: BorderSide(color: theme.primaryColor, width: 0.4),
      ),
      clipBehavior: Clip.none,
      child: Consumer(
        builder: (context, ref, child) {
          final isLoading =
              (module == Modules.adjustPrice &&
              ref.watch(
                canAccessResourceStateControllerProvider(
                  BsRoutine.adjustSalePrice,
                  BsResource.adjustSalePrice,
                ).select((s) => s.isLoading),
              ));

          final hasSelectedEnterprise = ref.watch(
            selectedEnterpriseStateControllerProvider.select((s) => s != null),
          );

          return InkWell(
            borderRadius: BorderRadius.circular(Sizes.p12),
            onTap: !hasSelectedEnterprise || isLoading ? null : accessModule,
            child: Stack(
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Using a circular container with a subtle background instead of a full image card
                      if (isLoading)
                        const LoadingWidget()
                      else
                        ModuleIcon(icon: icon),
                      gapH12,
                      ModuleName(module: module),
                    ],
                  ),
                ),
                if ((module == Modules.stockReplacement &&
                        ModuleIsFreeUntil.stockReplacementIsFree) ||
                    (module == Modules.adjustCost &&
                        ModuleIsFreeUntil.adjustCostIsFree))
                  const NewModuleBadge(),
                FavoriteIconButton(
                  module: module,
                  key: ValueKey('favorite_$module'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
