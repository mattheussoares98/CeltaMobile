import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../controllers/controllers.dart';

class LastSavedRequestsNumbers extends ConsumerWidget {
  const LastSavedRequestsNumbers({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lastSavedRequestNumber = ref.watch(
      pendingBuyRequestStateControllerProvider.select(
        (s) => s.value?.lastSavedRequestNumber,
      ),
    );

    if (lastSavedRequestNumber == null) {
      return const SliverToBoxAdapter();
    }

    final regex = RegExp(r'\(([\d\s\|]+)\)');
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(bottom: Sizes.p8),
        child: TitleAndSubTitle(
          title: 'Último(s) pedido(s) salvo(s)'.hardcoded,
          subTitle: regex
              .allMatches(lastSavedRequestNumber)
              .first
              .group(1)
              .toString(),
        ),
      ),
    );
  }
}
