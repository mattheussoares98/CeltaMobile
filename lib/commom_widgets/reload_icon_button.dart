import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReloadIconButton<T> extends ConsumerWidget {
  final ProviderOrFamily provider;
  const ReloadIconButton({super.key, required this.provider});

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

    return IconButton(
      onPressed: () => ref.invalidate(provider),
      icon: const Icon(Icons.refresh),
    );
  }
}
