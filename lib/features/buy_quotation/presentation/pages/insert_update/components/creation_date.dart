import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/features/buy_quotation/presentation/controllers/controller.dart';

class CreationDate extends ConsumerWidget {
  final int enterpriseCode;
  final int code;
  const CreationDate({
    super.key,
    required this.enterpriseCode,
    required this.code,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateOfCreation = ref.watch(
      completeBuyQuotationsStateControllerProvider(
        enterpriseCode,
        code.toString(),
      ).select((s) => s.value?.DateOfCreation),
    );

    if (dateOfCreation == null) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    return SliverToBoxAdapter(
      child: TitleAndSubTitle(
        title: 'Data de criação'.hardcoded,
        subTitle: DateFormat('dd/MM/yyyy HH:mm').format(dateOfCreation),
      ),
    );
  }
}
