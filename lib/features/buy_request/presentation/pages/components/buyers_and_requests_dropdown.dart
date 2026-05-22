import 'package:flutter/material.dart';

import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/buy_request/presentation/pages/components/components.dart';

class BuyersAndRequestsDropdown extends StatelessWidget {
  final bool enabled;
  final int enterpriseCode;
  const BuyersAndRequestsDropdown({
    super.key,
    required this.enabled,
    required this.enterpriseCode,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.sizeOf(context).width > Breakpoint.desktop;

    return RepaintBoundary(
      child: isDesktop
          ? _DesktopView(
              key: const ValueKey('desktop'),
              enabled: enabled,
              enterpriseCode: enterpriseCode,
            )
          : _MobileView(
              key: const ValueKey('mobile'),
              enabled: enabled,
              enterpriseCode: enterpriseCode,
            ),
    );
  }
}

class _DesktopView extends StatelessWidget {
  final bool enabled;
  final int enterpriseCode;
  const _DesktopView({
    super.key,
    required this.enabled,
    required this.enterpriseCode,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: BuyersDropdown(
            enabled: enabled,
            enterpriseCode: enterpriseCode,
          ),
        ),
        gapW8,
        Expanded(
          child: RequestTypeDropdown(
            enabled: enabled,
            enterpriseCode: enterpriseCode,
          ),
        ),
      ],
    );
  }
}

class _MobileView extends StatelessWidget {
  final bool enabled;
  final int enterpriseCode;
  const _MobileView({
    super.key,
    required this.enabled,
    required this.enterpriseCode,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BuyersDropdown(enabled: enabled, enterpriseCode: enterpriseCode),
        gapH8,
        RequestTypeDropdown(enabled: enabled, enterpriseCode: enterpriseCode),
      ],
    );
  }
}
