import 'dart:math';

import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

class BasePaginationButtons<T> extends ConsumerWidget {
  final void Function(int page) onChangePage;
  final int enterpriseCode;
  final ProviderListenable<AsyncValue<dynamic>> provider;

  const BasePaginationButtons({
    super.key,
    required this.onChangePage,
    required this.enterpriseCode,
    required this.provider,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final results = ref.watch(
      saleRequestsStateControllerProvider(
        enterpriseCode,
      ).select((s) => s.value),
    );

    if (results == null || results.totalPages <= 1) {
      return const SizedBox.shrink();
    }

    final int startItem = (results.actualPage - 1) * results.recordsByPage + 1;
    final int endItem = min(
      results.actualPage * results.recordsByPage,
      results.totalRecords,
    );

    return RepaintBoundary(
      child: FittedBox(
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: Sizes.p8,
              vertical: Sizes.p4,
            ),
            decoration: BoxDecoration(
              color: context.theme.cardColor,
              borderRadius: BorderRadius.circular(Sizes.p32),
              border: Border.all(
                color: context.theme.dividerColor.withAlpha(40),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(10),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: IntrinsicHeight(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _PageActionIcon(
                    provider: provider,
                    platformIcon: const PlatformIcon(
                      cupertinoIcon: CupertinoIcons.chevron_left,
                      materialIcon: Icons.chevron_left,
                    ),
                    onPressed: results.actualPage > 1
                        ? () => onChangePage(results.actualPage - 1)
                        : null,
                  ),

                  const _DefaultVerticalDivider(),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Sizes.p12),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Consumer(
                          builder: (context, ref, child) {
                            final isLoading = ref.watch(
                              provider.select((s) => s.isLoading),
                            );
                            return DefaultText(
                              '${results.actualPage} / ${results.totalPages}',
                              fontWeight: FontWeight.bold,
                              color: isLoading
                                  ? context.theme.disabledColor
                                  : null,
                            );
                          },
                        ),
                        DefaultText.caption(
                          '$startItem-$endItem de ${results.totalRecords}'
                              .hardcoded,
                          color: context.theme.hintColor,
                        ),
                      ],
                    ),
                  ),

                  const _DefaultVerticalDivider(),

                  _PageActionIcon(
                    provider: provider,
                    platformIcon: const PlatformIcon(
                      cupertinoIcon: CupertinoIcons.chevron_right,
                      materialIcon: Icons.chevron_right,
                    ),
                    onPressed: results.actualPage < results.totalPages
                        ? () => onChangePage(results.actualPage + 1)
                        : null,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DefaultVerticalDivider extends StatelessWidget {
  const _DefaultVerticalDivider();

  @override
  Widget build(BuildContext context) {
    return VerticalDivider(
      width: 1,
      color: context.theme.dividerColor.withAlpha(30),
    );
  }
}

class _PageActionIcon extends ConsumerWidget {
  final PlatformIcon platformIcon;
  final VoidCallback? onPressed;
  final ProviderListenable<AsyncValue<dynamic>> provider;

  const _PageActionIcon({
    required this.platformIcon,
    required this.onPressed,
    required this.provider,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(provider.select((s) => s.isLoading));

    return IconButton(
      onPressed: isLoading ? null : onPressed,

      visualDensity: VisualDensity.compact,
      icon: PlatformIcon(
        cupertinoIcon: platformIcon.cupertinoIcon,
        materialIcon: platformIcon.materialIcon,
        color: isLoading
            ? context.theme.disabledColor
            : context.theme.primaryColor,
        size: 18,
      ),
    );
  }
}
