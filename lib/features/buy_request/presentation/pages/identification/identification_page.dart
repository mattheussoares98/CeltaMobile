import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../components/components.dart';
import 'components/components.dart';

class IdentificationPage extends ConsumerWidget {
  const IdentificationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isDesktop = screenWidth > Breakpoint.desktop;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Sizes.p4),
        child: isDesktop
            ? const _DesktopView(key: ValueKey('desktop'))
            : const _MobileView(key: ValueKey('mobile')),
      ),
    );
  }
}

class _DesktopView extends StatelessWidget {
  const _DesktopView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Row(
          children: [
            Expanded(child: BuyersDropdown(isSliver: false)),
            gapW8,
            Expanded(child: RequestTypeDropdown(isSliver: false)),
          ],
        ),
        gapH8,
        SizedBox(width: Breakpoint.desktop, child: SupplierSearcher()),
        Expanded(child: SupplierItems(isSliver: false)),
      ],
    );
  }
}

class _MobileView extends StatelessWidget {
  const _MobileView({super.key});

  @override
  Widget build(BuildContext context) {
    return const ResponsiveScrollableWidget(
      isSliverPage: true,
      child: CustomScrollView(
        physics: ClampingScrollPhysics(),
        slivers: [
          BuyersDropdown(isSliver: true),
          gapSliverH8,
          RequestTypeDropdown(isSliver: true),
          gapSliverH8,
          SliverToBoxAdapter(child: SupplierSearcher()),
          SupplierItems(isSliver: true),
        ],
      ),
    );
  }
}
