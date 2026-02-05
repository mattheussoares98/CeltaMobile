import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../constants/constants.dart';
import '../../../../../core/domain/entities/entities.dart';
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

  const DefaultModuleButton({
    super.key,
    required this.route,
    required this.module,
    required this.cupertinoIcon,
    required this.materialIcon,
    this.passEnterpriseToNextRoute = true,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DefaultModuleButtonState();
}

class _DefaultModuleButtonState extends ConsumerState<DefaultModuleButton>
    with TryAccessRouteMixin {
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
                return InkWell(
                  onTap: selectedEnterprise == null
                      ? null
                      : () => tryAccessRoute(
                          widget.route,
                          widget.module,
                          pathParameters: {
                            if (widget.passEnterpriseToNextRoute)
                              'enterpriseCode':
                                  selectedEnterprise.Code.toString(),
                          },
                        ),
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
                            isIOS ? widget.cupertinoIcon : widget.materialIcon,
                            color: theme.primaryColor,
                          ),
                        ),
                        const SizedBox(height: Sizes.p12),
                        Text(
                          widget.route.module,
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
