import 'package:celta_inventario/core/presentation/theme/theme.dart';
import 'package:celta_inventario/localization/localization.dart';
import 'package:celta_inventario/routing/app_router.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toastification/toastification.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.sizeOf(context);
    debugPrint('${size.height.toInt()} x ${size.width.toInt()}');

    final goRouter = ref.watch(goRouterProvider);
    final language =
        ref.watch(languageControllerProvider).value ??
        ref.read(languageControllerProvider.notifier).language;
    return ToastificationWrapper(
      config: const ToastificationConfig(maxTitleLines: 10),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: FocusScope.of(context).unfocus,
        child: MaterialApp.router(
          routerConfig: goRouter,
          debugShowCheckedModeBanner: false,
          restorationScopeId: 'app',
          locale: Locale(language.code),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          onGenerateTitle: (context) => context.l10n.appTitle,
          theme: AppTheme.themeData(context.theme),
        ),
      ),
    );
  }
}
