import 'package:flutter/material.dart';

import '../../../../../constants/constants.dart';
import 'components.dart';

class BuyersAndRequestsDropdown extends StatelessWidget {
  final bool enabled;
  const BuyersAndRequestsDropdown({super.key, required this.enabled});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.sizeOf(context).width > Breakpoint.desktop;

    return SliverToBoxAdapter(
      child: RepaintBoundary(
        child: isDesktop
            ? _DesktopView(key: const ValueKey('desktop'), enabled: enabled)
            : _MobileView(key: const ValueKey('mobile'), enabled: enabled),
      ),
    );
  }
}

class _DesktopView extends StatelessWidget {
  final bool enabled;
  const _DesktopView({super.key, required this.enabled});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: BuyersDropdown(enabled: enabled)),
        gapW8,
        Expanded(child: RequestTypeDropdown(enabled: enabled)),
      ],
    );
  }
}

class _MobileView extends StatelessWidget {
  final bool enabled;
  const _MobileView({super.key, required this.enabled});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BuyersDropdown(enabled: enabled),
        gapH8,
        RequestTypeDropdown(enabled: enabled),
      ],
    );
  }
}
