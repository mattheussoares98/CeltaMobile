import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_sizes.dart';
import '../features/auth/presentation/controllers/controllers.dart';
import '../localization/string_hardcoded.dart';
import '../routing/app_router.dart';
import 'commom_widgets.dart';

class EmptyPlaceholderWidget extends ConsumerWidget {
  const EmptyPlaceholderWidget({super.key, required this.message});
  final String message;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(authStateControllerProvider);

    bool goToAuth =
        userState.value?.CrossIdentity_Usuario == null ||
        userState.value?.AccessKey == null;

    return Padding(
      padding: const EdgeInsets.all(Sizes.p16),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              message,
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            gapH32,
            PrimaryButton(
              onPressed: () => context.goNamed(
                goToAuth ? AppRoute.auth.name : AppRoute.home.name,
              ),
              text: goToAuth
                  ? 'Ir para login'.hardcoded
                  : 'Ir para home'.hardcoded,
            ),
          ],
        ),
      ),
    );
  }
}
