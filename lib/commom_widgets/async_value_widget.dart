import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/constants.dart';
import '../localization/string_hardcoded.dart';
import '../exceptions/exceptions.dart';
import 'commom_widgets.dart';

//! PERFORMANCE: This widget is a "Smart Guard."
//! It supports both direct [value] passing (Legacy) and [provider] passing (Performance).
//! When using [provider], it isolates rebuilds to this widget only.
class AsyncValueWidget<T> extends ConsumerWidget {
  final AsyncValue<T>? value;
  final ProviderListenable<AsyncValue<T>>? provider;
  final Widget Function(T)? data;
  final Widget? child;
  final VoidCallback? tryAgain;

  const AsyncValueWidget({
    super.key,
    this.value,
    this.provider,
    this.data,
    this.child,
    this.tryAgain,
  }) : assert(
         (value != null && data != null) || (provider != null && child != null),
         'Usage Error: Provide either (value + data) for standard use, or (provider + child) for performance isolation.',
       );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Determine the loading and error state.
    // If provider is passed, we use granular .select to prevent parent rebuilds.
    final bool isLoading;
    final Object? error;
    final bool hasData;
    final T? dataValue;

    if (provider != null) {
      isLoading = ref.watch(provider!.select((s) => s.isLoading));
      error = ref.watch(provider!.select((s) => s.error));
      hasData = ref.watch(provider!.select((s) => s.hasValue));
      dataValue =
          null; // Data is handled by the child widget via its own ref.watch
    } else {
      isLoading = value!.isLoading;
      error = value!.error;
      hasData = value!.hasValue;
      dataValue = value!.asData?.value;
    }

    if (isLoading) {
      return const Center(child: LoadingWidget());
    } else if (error != null) {
      return _ErrorWidget(error: error, tryAgain: tryAgain);
    } else if (!hasData) {
      return const SizedBox.shrink();
    }

    // PERFORMANCE: If we have a provider, we return the 'child' which is a
    // static widget tree. If we have a value, we execute the 'data' callback.
    return child ?? data!(dataValue as T);
  }
}

/// Sliver equivalent of the Universal AsyncWidget
class AsyncValueSliverWidget<T> extends ConsumerWidget {
  final AsyncValue<T>? value;
  final ProviderListenable<AsyncValue<T>>? provider;
  final Widget Function(T)? data;
  final Widget? child;
  final VoidCallback? tryAgain;

  const AsyncValueSliverWidget({
    super.key,
    this.value,
    this.provider,
    this.data,
    this.child,
    this.tryAgain,
  }) : assert(
         (value != null && data != null) || (provider != null && child != null),
         'Usage Error: Provide either (value + data) or (provider + child).',
       );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isLoading;
    final Object? error;
    final bool hasData;
    final T? dataValue;

    if (provider != null) {
      isLoading = ref.watch(provider!.select((s) => s.isLoading));
      error = ref.watch(provider!.select((s) => s.error));
      hasData = ref.watch(provider!.select((s) => s.hasValue));
      dataValue = null;
    } else {
      isLoading = value!.isLoading;
      error = value!.error;
      hasData = value!.hasValue;
      dataValue = value!.asData?.value;
    }

    if (isLoading) {
      return const SliverFillRemaining(
        hasScrollBody: false,
        child: Center(child: LoadingWidget()),
      );
    } else if (error != null) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: _ErrorWidget(error: error, tryAgain: tryAgain),
      );
    } else if (!hasData) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    // If using provider-mode, the 'child' must be a sliver.
    return child != null
        ? child!
        : SliverToBoxAdapter(child: data!(dataValue as T));
  }
}

class _ErrorWidget extends StatelessWidget {
  final Object? error;
  final VoidCallback? tryAgain;
  const _ErrorWidget({required this.error, required this.tryAgain});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(Sizes.p8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            parseErrorMessage(error),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.red,
              fontStyle: FontStyle.italic,
            ),
          ),
          if (tryAgain != null)
            TextButton.icon(
              onPressed: tryAgain,
              label: Text('Tentar novamente'.hardcoded),
              icon: Icon(
                theme.platform == TargetPlatform.iOS
                    ? CupertinoIcons.refresh
                    : Icons.refresh,
              ),
            ),
        ],
      ),
    );
  }
}
