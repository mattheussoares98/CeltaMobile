import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/features/enterprise_manager/presentation/pages/enterprise_manager/reports/components/components.dart';

class ReportsPage extends ConsumerStatefulWidget {
  final ScrollController scrollController;
  const ReportsPage({super.key, required this.scrollController});

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
        controller: widget.scrollController,
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
