import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../constants/constants.dart';
import '../core/domain/entities/entities.dart';
import '../localization/string_hardcoded.dart';

class DefaultPaginationButtons<T> extends ConsumerWidget {
  final EcPaginationResults<T>? paginationResults;
  final void Function(int page) onChangePage;
  final ProviderListenable<AsyncValue<dynamic>> provider;

  const DefaultPaginationButtons({
    super.key,
    required this.paginationResults,
    required this.onChangePage,
    required this.provider,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final results = paginationResults;
    if (results == null || results.totalPages <= 1) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;

    final isLoading = ref.watch(provider.select((s) => s.isLoading));

    final int startItem = (results.actualPage - 1) * results.recordsByPage + 1;
    final int endItem = min(
      results.actualPage * results.recordsByPage,
      results.totalRecords,
    );
    //TODO improve this widget performance

    return RepaintBoundary(
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
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _PageActionIcon(
                icon: isIOS ? CupertinoIcons.chevron_left : Icons.chevron_left,
                onPressed: !isLoading && results.actualPage > 1
                    ? () => onChangePage(results.actualPage - 1)
                    : null,
              ),

              Container(
                height: 20,
                width: 1,
                color: theme.dividerColor.withAlpha(30),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Sizes.p12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${results.actualPage} / ${results.totalPages}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        height: 1.1,
                        color: isLoading ? theme.disabledColor : null,
                      ),
                    ),
                    Text(
                      '$startItem-$endItem de ${results.totalRecords}'
                          .hardcoded,
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontSize: 9,
                        height: 1.0,
                        color: theme.hintColor,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                height: 20,
                width: 1,
                color: theme.dividerColor.withAlpha(30),
              ),

              _PageActionIcon(
                icon: isIOS
                    ? CupertinoIcons.chevron_right
                    : Icons.chevron_right,
                onPressed: !isLoading && results.actualPage < results.totalPages
                    ? () => onChangePage(results.actualPage + 1)
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PageActionIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;

  const _PageActionIcon({required this.icon, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDisabled = onPressed == null;

    return IconButton(
      onPressed: onPressed,

      visualDensity: VisualDensity.compact,
      icon: Icon(
        icon,
        size: 18,
        color: isDisabled ? theme.disabledColor : theme.primaryColor,
      ),
    );
  }
}
