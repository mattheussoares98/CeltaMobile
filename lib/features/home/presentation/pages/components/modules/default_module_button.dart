import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../../../../core/domain/entities/entities.dart';
import '../../../../../../core/presentation/controllers/bs_version/bs_version.dart';
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
  final DateTime? minimumBsVersionDate;

  const DefaultModuleButton({
    super.key,
    required this.route,
    required this.module,
    required this.cupertinoIcon,
    required this.materialIcon,
    this.passEnterpriseToNextRoute = true,
    this.minimumBsVersionDate,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final isIOS = theme.platform == TargetPlatform.iOS;
    final icon = isIOS ? cupertinoIcon : materialIcon;

    final isLoading =
        (module == Modules.adjustPrice &&
            ref.watch(
              canAccessResourceStateControllerProvider(
                BsRoutine.adjustSalePrice,
                BsResource.adjustSalePrice,
              ).select((s) => s.isLoading),
            )) ||
        (minimumBsVersionDate != null &&
            ref.watch(
              bsVersionStateControllerProvider.select((s) => s.isLoading),
            ));

    final hasSelectedEnterprise = ref.watch(
      selectedEnterpriseStateControllerProvider.select((s) => s != null),
    );

    void accessModule() {
      final enterpriseCode = ref.read(
        selectedEnterpriseStateControllerProvider.select((s) => s?.Code),
      );

      ref
          .read(tryAccessModuleControllerProvider(module).notifier)
          .tryAccess(
            context: context,
            route: route,
            enterpriseCode: enterpriseCode,
            replace: true,
            pathParameters: {
              if (passEnterpriseToNextRoute)
                'enterpriseCode': enterpriseCode.toString(),
            },
          );
    }

    return Material(
      color: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Sizes.p12),
        side: BorderSide(color: theme.primaryColor, width: 0.4),
      ),
      clipBehavior: Clip.none,
      child: InkWell(
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
                  const SizedBox(height: Sizes.p12),
                  ModuleName(route: route),
                ],
              ),
            ),
            if (module == Modules.stockReplacement &&
                ModuleIsFreeUntil.stockReplacementIsFree)
              const NewModuleBadge(),
            FavoriteIconButton(
              module: module,
              key: ValueKey('favorite_$module'),
            ),
          ],
        ),
      ),
    );
  }
}
