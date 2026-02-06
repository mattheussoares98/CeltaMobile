import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'commom_widgets.dart';

class ReloadIconButton<T> extends ConsumerWidget {
  final ProviderListenable<AsyncValue<T>> provider;
  final VoidCallback tryAgain;

  const ReloadIconButton({
    super.key,
    required this.provider,
    required this.tryAgain,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isMobile =
        theme.platform == TargetPlatform.android ||
        theme.platform == TargetPlatform.iOS;
    final showIcon = !isMobile;

    if (!showIcon) {
      return const SizedBox.shrink();
    }

    return OptimazedAsyncValueWidget(
      provider: provider,
      tryAgain: null,
      child: IconButton(onPressed: tryAgain, icon: const Icon(Icons.refresh)),
    );
  }
}
