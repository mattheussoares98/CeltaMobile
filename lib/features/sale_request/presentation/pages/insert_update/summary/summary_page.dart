import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/sale_request/presentation/pages/pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SummaryPage extends ConsumerWidget {
  const SummaryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: Sizes.p8),
      child: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: SaleRequestPersonalizedCode()),
              SliverToBoxAdapter(
                child: DebounceField(type: DebounceFieldType.observations),
              ),
              gapSliverH8,
              SliverToBoxAdapter(
                child: DebounceField(type: DebounceFieldType.instructions),
              ),
              gapSliverH8,
              SliverToBoxAdapter(child: RequestTypeDropDown()),
              gapSliverH8,
              SliverToBoxAdapter(child: SellerDropdown()),
              gapSliverH8,
              SliverToBoxAdapter(child: SelectedCustomer()),
              gapSliverH8,
              ItemsPage(isSliver: true),
              gapSliverH48,
            ],
          ),
          Positioned(
            bottom: Sizes.p8,
            right: 0,
            left: 0,
            child: ProcessAndSaveButtons(),
          ),
        ],
      ),
    );
  }
}
