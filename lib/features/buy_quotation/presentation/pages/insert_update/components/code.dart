import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/widgets.dart';

import 'package:celta_inventario/commom_widgets/commom_widgets.dart';

class Code extends StatelessWidget {
  final int code;
  const Code({super.key, required this.code});

  @override
  Widget build(BuildContext context) {
    if (code == 0) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    return SliverToBoxAdapter(
      child: TitleAndSubTitle(
        title: context.l10n.code,
        subTitle: code.toString(),
      ),
    );
  }
}
