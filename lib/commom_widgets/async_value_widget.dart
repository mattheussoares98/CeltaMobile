import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/constants.dart';
import '../localization/string_hardcoded.dart';
import '../exceptions/exceptions.dart';
import 'commom_widgets.dart';

class AsyncValueWidget<T> extends StatelessWidget {
  const AsyncValueWidget({
    super.key,
    required this.value,
    required this.tryAgain,
    required this.data,
    this.isSliver,
  });
  final AsyncValue<T> value;
  final Widget Function(T) data;
  final VoidCallback? tryAgain;
  final bool? isSliver;

  @override
  Widget build(BuildContext context) {
    if (value.isLoading) {
      return _Loading(isSliver: isSliver);
    }

    return value.when(
      data: data,
      loading: () => _Loading(isSliver: isSliver),
      error: (e, st) => isSliver == true
          ? SliverToBoxAdapter(
              child: _Error(e: e, tryAgain: tryAgain),
            )
          : _Error(e: e, tryAgain: tryAgain),
    );
  }
}

class OptimazedAsyncValueWidget<T> extends ConsumerWidget {
  //!this widget was made for largest pages below to avoid rebuild unecessary
  const OptimazedAsyncValueWidget({
    super.key,
    required this.provider,
    required this.tryAgain,
    required this.child,
    this.isSliver,
  });
  final ProviderListenable<AsyncValue<T>> provider;
  final Widget child;
  final VoidCallback? tryAgain;
  final bool? isSliver;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(provider.select((s) => s.isLoading));
    final error = ref.watch(provider.select((s) => s.error));

    if (isLoading) {
      return _Loading(isSliver: isSliver);
    } else if (error != null) {
      return isSliver == true
          ? SliverToBoxAdapter(
              child: _Error(e: error, tryAgain: tryAgain),
            )
          : _Error(e: error, tryAgain: tryAgain);
    }

    return child;
  }
}

class _Loading extends StatelessWidget {
  final bool? isSliver;
  const _Loading({required this.isSliver});

  @override
  Widget build(BuildContext context) {
    if (isSliver == true) {
      return const SliverToBoxAdapter(child: Center(child: LoadingWidget()));
    }
    return const Center(child: LoadingWidget());
  }
}

class _Error extends StatelessWidget {
  final Object e;
  final VoidCallback? tryAgain;
  const _Error({required this.e, required this.tryAgain});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDesktop = MediaQuery.sizeOf(context).width > Breakpoint.tablet;

    return Padding(
      padding: const EdgeInsets.all(Sizes.p8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            parseErrorMessage(e),
            textAlign: TextAlign.center,
            maxLines: isDesktop ? 3 : null,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.red,
              fontStyle: FontStyle.italic,
              fontSize: 12,
            ),
          ),
          if (tryAgain != null)
            PrimaryTextButton(
              text: 'Tentar novamente'.hardcoded,
              onPressed: tryAgain,
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
