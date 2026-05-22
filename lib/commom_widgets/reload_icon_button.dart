import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';

class ReloadIconButton<T> extends ConsumerWidget {
  final ProviderBase<AsyncValue<T>> provider;

  const ReloadIconButton({super.key, required this.provider});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMobile =
        context.theme.platform == TargetPlatform.android ||
        PlatformUtil.isCupertino;
    final showIcon = !isMobile;

    if (!showIcon) {
      return const SizedBox.shrink();
    }

    return IconButton(
      onPressed: ref.watch(provider.select((s) => s.isLoading))
          ? null
          : () => ref.invalidate(provider),
      icon: const Icon(Icons.refresh),
    );
  }
}
