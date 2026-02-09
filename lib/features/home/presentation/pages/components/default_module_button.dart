import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../../../../core/domain/entities/entities.dart';
import '../../../../../core/presentation/controllers/bs_version/bs_version.dart';
import '../../../../../core/presentation/controllers/resource/resource.dart';
import '../../../../../core/presentation/helpers/helpers.dart';
import '../../../../../core/presentation/mixins/mixins.dart';
import '../../../../../routing/routing.dart';
import '../../../../enterprises/presentation/controllers/controllers.dart';
import '../../controllers/controllers.dart';

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
  final now = DateTime.now();
  @override
  Widget build(BuildContext context) {
    final selectedEnterprise = ref.watch(
      selectedEnterpriseStateControllerProvider,
    );

    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;
    final isFavorite = ref.watch(
      favoriteModulesStateControllerProvider.select(
        (s) => s.value?.any((x) => x == widget.module) ?? false,
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
                final loadingAdjustPricePermission =
                    (widget.module == Modules.adjustPrice &&
                    ref.watch(
                      canAccessResourceStateControllerProvider(
                        BsRoutine.adjustSalePrice,
                        BsResource.adjustSalePrice,
                      ).select((s) => s.isLoading),
                    ));

                final loadingBsVersion =
                    widget.minimumBsVersionDate != null &&
                    ref.watch(
                      bsVersionStateControllerProvider.select(
                        (s) => s.isLoading,
                      ),
                    );

                final isLoading =
                    loadingAdjustPricePermission || loadingBsVersion;

                return InkWell(
                  onTap: selectedEnterprise == null || isLoading
                      ? null
                      : () async {
                          if (widget.minimumBsVersionDate != null) {
                            final bsVersionDate = await ref.read(
                              bsVersionStateControllerProvider.future,
                            );

                            if (bsVersionDate?.isBefore(
                                  widget.minimumBsVersionDate!,
                                ) ??
                                false) {
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
                          tryAccessRoute(
                            widget.route,
                            widget.module,
                            selectedEnterprise.Code,
                            replace: true,
                            pathParameters: {
                              if (widget.passEnterpriseToNextRoute)
                                'enterpriseCode':
                                    selectedEnterprise.Code.toString(),
                            },
                          );
                        },
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Using a circular container with a subtle background instead of a full image card
                        isLoading
                            ? const LoadingWidget()
                            : Container(
                                padding: const EdgeInsets.all(Sizes.p8),
                                decoration: BoxDecoration(
                                  color: theme.primaryColor.withAlpha(50),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  isIOS
                                      ? widget.cupertinoIcon
                                      : widget.materialIcon,
                                  color: theme.primaryColor,
                                ),
                              ),
                        const SizedBox(height: Sizes.p12),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: Sizes.p4,
                          ),
                          child: Text(
                            widget.route.module,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          if (widget.module == Modules.stockReplacement &&
              ModuleIsFreeUntil.stockReplacementIsFree)
            Positioned(
              top: 0,
              left: 0,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(Sizes.p8),
                  bottomRight: Radius.circular(Sizes.p8),
                ),
                child: Container(
                  color: Colors.red,
                  padding: const EdgeInsets.symmetric(
                    vertical: Sizes.p4,
                    horizontal: Sizes.p16,
                  ),
                  child: Text(
                    'Novo'.hardcoded,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: Colors.white,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ),
            ),
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              onPressed: () => ref
                  .read(favoriteModulesStateControllerProvider.notifier)
                  .toggle(widget.module),
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
