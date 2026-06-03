import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SaleRequestPersonalizedCode extends ConsumerWidget {
  const SaleRequestPersonalizedCode({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final personalizedCode = ref.watch(
      insertUpdateStateControllerProvider.select(
        (s) => s.value?.personalizedCode,
      ),
    );

    return personalizedCode == null
        ? const SizedBox.shrink()
        : Padding(
            padding: const EdgeInsets.only(bottom: Sizes.p8),
            child: TitleAndSubTitle(
              title: 'Pedido'.hardcoded,
              subTitle: personalizedCode,
              textAlign: TextAlign.center,
            ),
          );
  }
}
