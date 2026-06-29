import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/enterprise_manager/presentation/pages/enterprise_manager/reports/components/components.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReportsPage extends ConsumerStatefulWidget {
  final ScrollController scrollController;
  const ReportsPage({super.key, required this.scrollController});

  @override
  ConsumerState<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends ConsumerState<ReportsPage> {
  final enterpriseController = TextEditingController();
  final usageTypeController = TextEditingController();

  @override
  void dispose() {
    enterpriseController.dispose();
    usageTypeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.sizeOf(context).width >= Breakpoint.desktop;
    final filterEnterprise = SizedBox(
      width: Breakpoint.tablet,
      child: BaseTextFormField(
        controller: enterpriseController,
        hintText: 'Filtrar empresa'.hardcoded,
        labelText: 'Filtrar empresa'.hardcoded,
      ),
    );
    final filterUsageType = SizedBox(
      width: Breakpoint.tablet,
      child: BaseTextFormField(
        controller: usageTypeController,
        hintText: 'Filtrar tipo de uso'.hardcoded,
        labelText: 'Filtrar tipo de uso'.hardcoded,
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Sizes.p4),
      child: CustomScrollView(
        controller: widget.scrollController,
        slivers: [
          gapSliverH8,
          const StartAndEndDate(),
          gapSliverH8,
          if (isDesktop)
            SliverToBoxAdapter(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(child: filterEnterprise),
                  gapW12,
                  Flexible(child: filterUsageType),
                ],
              ),
            )
          else
            SliverToBoxAdapter(
              child: Column(
                children: [filterEnterprise, gapH8, filterUsageType],
              ),
            ),
          ReportsItems(
            enterpriseController: enterpriseController,
            usageTypeController: usageTypeController,
          ),
        ],
      ),
    );
  }
}
