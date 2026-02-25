import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../constants/constants.dart';
import 'components/components.dart';

class ReportsPage extends ConsumerWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const CustomScrollView(
      slivers: [gapSliverH8, StartAndEndDate(), gapSliverH8, ReportsItems()],
    );
  }
}
