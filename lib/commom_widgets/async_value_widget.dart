import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../localization/string_hardcoded.dart';
import '../exceptions/exceptions.dart';

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
    return value.when(
      data: data,
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              parseErrorMessage(e),
              style: TextStyle(color: Colors.red, fontStyle: FontStyle.italic),
            ),
            TextButton.icon(
              onPressed: tryAgain,
              label: Text('Tentar novamente'.hardcoded),
              icon: Icon(
                defaultTargetPlatform == TargetPlatform.iOS
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
    return value.when(
      data: data,
      loading: () => const SliverFillRemaining(
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (e, st) => SliverFillRemaining(
        child: Center(
          child: TextButton(
            onPressed: tryAgain,
            child: Text('Erro não esperado. Tente novamente'.hardcoded),
          ),
        ),
      ),
    );
  }
}
