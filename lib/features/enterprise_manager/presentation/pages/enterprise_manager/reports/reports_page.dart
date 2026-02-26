import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../../../../localization/string_hardcoded.dart';
import 'components/components.dart';

class ReportsPage extends ConsumerStatefulWidget {
  const ReportsPage({super.key});

  @override
  ConsumerState<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends ConsumerState<ReportsPage> {
  final filterController = TextEditingController();

  @override
  void dispose() {
    filterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Sizes.p4),
      child: CustomScrollView(
        slivers: [
          gapSliverH8,
          const StartAndEndDate(),
          gapSliverH8,
          SliverToBoxAdapter(
            child: DefaultTextFormField(
              controller: filterController,
              hintText: 'Filtrar empresa'.hardcoded,
              labelText: 'Filtrar empresa'.hardcoded,
            ),
          ),
          ReportsItems(filterController: filterController),
        ],
      ),
    );
  }
}
