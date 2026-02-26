import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../constants/constants.dart';
import 'components/components.dart';

class ReportsPage extends ConsumerWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: Sizes.p4),
      child: Column(
        children: [
          gapH8,
          StartAndEndDate(),
          gapH8,
          Expanded(child: ReportsItems()),
        ],
      ),
    );
  }
}
