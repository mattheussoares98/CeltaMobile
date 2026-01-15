import 'package:flutter/widgets.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../localization/string_hardcoded.dart';

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
        title: 'Código'.hardcoded,
        subTitle: code.toString(),
      ),
    );
  }
}
