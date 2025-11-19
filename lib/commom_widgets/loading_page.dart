import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/constants.dart';
import 'commom_widgets.dart';

class LoadingPage extends ConsumerWidget {
  final String? title;
  final List<ProviderListenable<AsyncValue<dynamic>>> providers;
  const LoadingPage({super.key, this.title, required this.providers});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isIos = theme.platform == TargetPlatform.iOS;
    final double size = isIos ? Sizes.p32 : Sizes.p48;

    bool shouldShowLoading = false;

    for (final provider in providers) {
      //* Even jump to another provider in the loop, the previous provider still listening
      bool isLoading = ref.watch(provider.select((s) => s.isLoading));

      if (isLoading) {
        shouldShowLoading = true;
        break;
      }
    }

    if (!shouldShowLoading) {
      return const SizedBox.shrink();
    }

    return Scaffold(
      backgroundColor: theme.disabledColor.withAlpha(50),
      body: Center(
        child: LoadingWidget(size: size, title: title),
      ),
    );
  }
}
