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
  });
  final AsyncValue<T> value;
  final Widget Function(T) data;
  final VoidCallback? tryAgain;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return value.when(
      data: data,
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Padding(
        padding: const EdgeInsets.all(Sizes.p8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              parseErrorMessage(e),
              textAlign: TextAlign.center,
              style: TextStyle(
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
      ),
    );
  }
}

/// Sliver equivalent of [AsyncValueWidget]
class AsyncValueSliverWidget<T> extends StatelessWidget {
  const AsyncValueSliverWidget({
    super.key,
    required this.value,
    required this.data,
    required this.tryAgain,
  });
  final AsyncValue<T> value;
  final Widget Function(T) data;
  final VoidCallback? tryAgain;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return value.when(
      data: data,
      loading: () => const SliverToBoxAdapter(
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (e, st) => SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                parseErrorMessage(e),
                textAlign: TextAlign.center,
                style: TextStyle(
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
        ),
      ),
    );
  }
}
