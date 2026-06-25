import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UnselectedMessage extends StatelessWidget {
  final String title;
  const UnselectedMessage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Row(
        children: [
          Flexible(
            child: DefaultText.titleMedium(
              title,
              color: Colors.red,
              fontStyle: FontStyle.italic,
            ),
          ),
          gapW12,
          const PlatformIcon(
            cupertinoIcon: CupertinoIcons.exclamationmark_triangle,
            materialIcon: Icons.report_problem_rounded,
            color: Colors.amber,
          ),
        ],
      ),
    );
  }
}
