import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/sale_request/presentation/pages/pages.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SummaryPage extends ConsumerWidget {
  const SummaryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDesktop =
        (PlatformUtil.isDesktop || PlatformUtil.isWeb) &&
        MediaQuery.sizeOf(context).width > Breakpoint.desktop;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Sizes.p8),
      child: Stack(
        children: [
          CustomScrollView(
            slivers: [
              const SliverToBoxAdapter(child: Summary()),
              gapSliverH8,
              if (isDesktop) ...[
                const SliverToBoxAdapter(
                  child: Row(
                    children: [
                      Expanded(
                        child: DebounceField(
                          type: DebounceFieldType.observations,
                        ),
                      ),
                      gapW8,
                      Expanded(
                        child: DebounceField(
                          type: DebounceFieldType.instructions,
                        ),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                const SliverToBoxAdapter(
                  child: DebounceField(type: DebounceFieldType.observations),
                ),
                gapSliverH8,
                const SliverToBoxAdapter(
                  child: DebounceField(type: DebounceFieldType.instructions),
                ),
              ],
              gapSliverH8,
              if (isDesktop) ...[
                const SliverToBoxAdapter(
                  child: Row(
                    children: [
                      Expanded(child: RequestTypeDropDown()),
                      gapW8,
                      Expanded(child: SellerDropdown()),
                    ],
                  ),
                ),
              ] else ...[
                const SliverToBoxAdapter(child: RequestTypeDropDown()),
                gapSliverH8,
                const SliverToBoxAdapter(child: SellerDropdown()),
              ],
              gapSliverH8,
              const SliverToBoxAdapter(
                child: ResponsiveCenter(child: SelectedCustomer()),
              ),
              gapSliverH8,
              const ItemsPage(isSliver: true),
              gapSliverH80,
            ],
          ),
          const Positioned(
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
