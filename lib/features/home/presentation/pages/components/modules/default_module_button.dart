import 'dart:async';

import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/resource/resource.dart';
import 'package:celta_inventario/features/enterprises/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/home/presentation/model/model.dart';
import 'package:celta_inventario/features/home/presentation/pages/components/components.dart';
import 'package:celta_inventario/routing/routing.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DefaultModuleButton extends HookConsumerWidget {
  final Routes route;
  final Modules module;
  final PlatformIcon platformIcon;
  final bool passEnterpriseToNextRoute;

  const DefaultModuleButton({
    super.key,
    required this.route,
    required this.module,
    required this.platformIcon,
    this.passEnterpriseToNextRoute = true,
  });

  DateTime get _now => DateTime.now();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final internalLoading = useState(false);

    void accessModule() async {
      Timer? loadingTimer;

      try {
        Routes? selectedActionRoute;
        if (const {
          Routes.saleRequestActionSelector,
          Routes.buyRequestActionSelector,
        }.contains(route)) {
          final List<PageActionSelectorModel> actions;
          String title;
          if (route == Routes.saleRequestActionSelector) {
            actions = SaleRequestActions.get(context);
            title = context.l10n.coreModulesSaleRequest;
          } else {
            actions = BuyRequestActions.get(context);
            title = context.l10n.coreModulesBuyRequest;
          }

          selectedActionRoute = await BaseActionSelector.show(
            context,
            actions: actions,
            title: title,
          );
          if (selectedActionRoute == null) return;
        }
        final enterpriseCode = ref.read(
          selectedEnterpriseStateControllerProvider.select((s) => s?.Code),
        );

        if (!context.mounted) return;

        loadingTimer = Timer(const Duration(milliseconds: 250), () {
          if (context.mounted) {
            internalLoading.value = true;
          }
        });

        await ref
            .read(tryAccessModuleControllerProvider.notifier)
            .tryAccess(
              context: context,
              module: module,
              route: selectedActionRoute ?? route,
              enterpriseCode: enterpriseCode,
              createSubRoute: true,
              pathParameters: passEnterpriseToNextRoute
                  ? {'enterpriseCode': enterpriseCode.toString()}
                  : null,
            );
      } finally {
        loadingTimer?.cancel();
        if (context.mounted) {
          internalLoading.value = false;
        }
      }
    }

    return Material(
      color: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Sizes.p12),
        side: BorderSide(color: context.theme.primaryColor, width: 0.4),
      ),
      child: Consumer(
        builder: (context, ref, child) {
          final isLoading =
              internalLoading.value ||
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
                    children: [
                      // Using a circular container with a subtle background instead of a full image card
                      if (isLoading)
                        const LoadingWidget()
                      else
                        ModuleIcon(platformIcon: platformIcon, module: module),
                      gapH12,
                      ModuleName(module: module),
                    ],
                  ),
                ),
                if ((module == Modules.productsRegister))
                  MessageBadge(message: context.l10n.suspended),
                if (module == Modules.processAuthorization &&
                    _now.isBefore(DateTime(2026, 8, 13)))
                  MessageBadge(message: context.l10n.newAction),
                if (module == Modules.printLabel &&
                    _now.isBefore(DateTime(2026, 10, 09)))
                  MessageBadge(message: context.l10n.newAction),
                if (module == Modules.synchronizer)
                  MessageBadge(message: context.l10n.newAction),
                if (module == Modules.buyMovement &&
                    _now.isBefore(DateTime(2026, 9)))
                  MessageBadge(message: context.l10n.newAction),
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
