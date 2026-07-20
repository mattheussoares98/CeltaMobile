import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/resource/resource.dart';
import 'package:celta_inventario/features/enterprises/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/home/presentation/pages/components/components.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/routing/routing.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DefaultModuleButton extends ConsumerWidget {
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void accessModule() async {
      Routes? saleRequestNextRoute;
      if (route == Routes.saleRequestActionSelector) {
        saleRequestNextRoute = await BaseActionSelector.show(
          context,
          actions: SaleRequestActions.get(context),
          title: 'Pedido de vendas'.hardcoded,
        );
        if (saleRequestNextRoute == null) return;
      }
      final enterpriseCode = ref.read(
        selectedEnterpriseStateControllerProvider.select((s) => s?.Code),
      );

      if (!context.mounted) return;
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
        side: BorderSide(color: context.theme.primaryColor, width: 0.4),
      ),
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
                  MessageBadge(message: 'Suspenso'.hardcoded),
                if ((module == Modules.processAuthorization) &&
                    DateTime.now().isBefore(DateTime(2026, 8, 13)))
                  MessageBadge(message: 'Novo'.hardcoded),
                if (module == Modules.synchronizer)
                  MessageBadge(message: 'Em breve'.hardcoded),
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
