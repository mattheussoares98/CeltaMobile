import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../constants/constants.dart';
import '../features/sale_request/presentation/controllers/controllers.dart';
import '../localization/string_hardcoded.dart';

class DefaultPaginationButtons<T> extends ConsumerWidget {
  final void Function(int page) onChangePage;
  final int enterpriseCode;
  final ProviderListenable<AsyncValue<dynamic>> provider;

  const DefaultPaginationButtons({
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
    //TODO test

    if (results == null || results.totalPages <= 1) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;

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
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(Sizes.p32),
              border: Border.all(color: theme.dividerColor.withAlpha(40)),
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
                    icon: isIOS
                        ? CupertinoIcons.chevron_left
                        : Icons.chevron_left,
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
                            return Text(
                              '${results.actualPage} / ${results.totalPages}',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                height: 1.1,
                                color: isLoading ? theme.disabledColor : null,
                              ),
                            );
                          },
                        ),
                        Text(
                          '$startItem-$endItem de ${results.totalRecords}'
                              .hardcoded,
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontSize: 9,
                            height: 1.0,
                            color: theme.hintColor,
                            // fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const _DefaultVerticalDivider(),

                  _PageActionIcon(
                    provider: provider,
                    icon: isIOS
                        ? CupertinoIcons.chevron_right
                        : Icons.chevron_right,
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
      color: Theme.of(context).dividerColor.withAlpha(30),
    );
  }
}

class _PageActionIcon extends ConsumerWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final ProviderListenable<AsyncValue<dynamic>> provider;

  const _PageActionIcon({
    required this.icon,
    required this.onPressed,
    required this.provider,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isLoading = ref.watch(provider.select((s) => s.isLoading));

    return IconButton(
      onPressed: isLoading ? null : onPressed,

      visualDensity: VisualDensity.compact,
      icon: Icon(
        icon,
        size: 18,
        color: isLoading ? theme.disabledColor : theme.primaryColor,
      ),
    );
  }
}
