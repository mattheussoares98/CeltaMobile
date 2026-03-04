import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../../../../core/domain/entities/entities.dart';
import '../../../../../../core/presentation/controllers/bs_version/bs_version.dart';
import '../../../../../../core/presentation/controllers/resource/resource.dart';
import '../../../../../../core/presentation/helpers/helpers.dart';
import '../../../../../../core/presentation/mixins/mixins.dart';
import '../../../../../../routing/routing.dart';
import '../../../../../enterprises/presentation/controllers/controllers.dart';
import '../components.dart';

class DefaultModuleButton extends ConsumerStatefulWidget {
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
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DefaultModuleButtonState();
}

class _DefaultModuleButtonState extends ConsumerState<DefaultModuleButton>
    with TryAccessRouteMixin {
  Future<void> toggleFavorite() async {
    if (widget.minimumBsVersionDate != null) {
      final bsVersionDate = await ref.read(
        bsVersionStateControllerProvider.future,
      );

      if (bsVersionDate?.isBefore(widget.minimumBsVersionDate!) ?? false) {
        showAlertDialog(
          context: context,
          title: 'Atualize o BS'.hardcoded,
          content:
              'A versão do BS precisa ser atualizada para utilizar essa funcionalidade'
                  .hardcoded,
        );
        return;
      }
    }
    final enterpriseCode = ref.read(
      selectedEnterpriseStateControllerProvider.select((s) => s!.Code),
    );

    //TODO create a provider for this
    tryAccessRoute(
      widget.route,
      widget.module,
      enterpriseCode,
      replace: true,
      pathParameters: {
        if (widget.passEnterpriseToNextRoute)
          'enterpriseCode': enterpriseCode.toString(),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final isIOS = theme.platform == TargetPlatform.iOS;
    final icon = isIOS ? widget.cupertinoIcon : widget.materialIcon;

    final isLoading =
        (widget.module == Modules.adjustPrice &&
            ref.watch(
              canAccessResourceStateControllerProvider(
                BsRoutine.adjustSalePrice,
                BsResource.adjustSalePrice,
              ).select((s) => s.isLoading),
            )) ||
        (widget.minimumBsVersionDate != null &&
            ref.watch(
              bsVersionStateControllerProvider.select((s) => s.isLoading),
            ));

    final hasSelectedEnterprise = ref.watch(
      selectedEnterpriseStateControllerProvider.select((s) => s != null),
    );

    return Material(
      color: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Sizes.p12),
        side: BorderSide(color: theme.primaryColor, width: 0.4),
      ),
      clipBehavior: Clip.none,
      child: InkWell(
        borderRadius: BorderRadius.circular(Sizes.p12),
        onTap: !hasSelectedEnterprise || isLoading ? null : toggleFavorite,
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
                  ModuleName(route: widget.route),
                ],
              ),
            ),
            if (widget.module == Modules.stockReplacement &&
                ModuleIsFreeUntil.stockReplacementIsFree)
              const NewModuleBadge(),
            FavoriteIconButton(
              module: widget.module,
              key: ValueKey('favorite_${widget.module}'),
            ),
          ],
        ),
      ),
    );
  }
}
