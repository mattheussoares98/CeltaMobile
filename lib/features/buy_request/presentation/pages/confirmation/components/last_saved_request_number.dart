import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../controllers/controllers.dart';

class LastSavedRequestNumber extends ConsumerWidget {
  const LastSavedRequestNumber({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendingAsync = ref.watch(pendingBuyRequestStateControllerProvider);
    final regex = RegExp(r'\(([\d\s\|]+)\)');

    return SliverToBoxAdapter(
      child: TitleAndSubTitle(
        title: 'Último pedido salvo'.hardcoded,
        subTitle: regex
            .allMatches(pendingAsync.value!.lastSavedRequestNumber!)
            .first
            .group(1)
            .toString(),
      ),
    );
  }
}
