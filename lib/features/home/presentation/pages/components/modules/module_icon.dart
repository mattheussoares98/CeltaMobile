import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/process_authorization/presentation/controllers/controllers.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ModuleIcon extends StatelessWidget {
  const ModuleIcon({
    super.key,
    required this.platformIcon,
    required this.module,
  });

  final PlatformIcon platformIcon;
  final Modules module;

  @override
  Widget build(BuildContext context) {
    final color = context.theme.primaryColor;
    return Container(
      padding: const EdgeInsets.all(Sizes.p8),
      decoration: BoxDecoration(
        color: color.withAlpha(50),
        shape: BoxShape.circle,
      ),
      child: Consumer(
        builder: (contex_, ref, _) {
          if (module == Modules.processAuthorization) {
            final quantity = ref.watch(
              statisticsStateControllerProvider.select(
                (s) => s.value?.openedJudgements,
              ),
            );

            return QuantityBadge(
              quantity: quantity,
              platformIcon: platformIcon,
              isSelected: true,
              animateInfinite: true,
            );
          }

          return platformIcon;
        },
      ),
    );
  }
}
