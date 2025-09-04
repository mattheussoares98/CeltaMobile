import '/localization/string_hardcoded.dart';
import '/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    debugPrint('${size.height.toInt()} x ${size.width.toInt()}');

    final goRouter = ref.watch(goRouterProvider);
    final theme = Theme.of(context);
    return MaterialApp.router(
      routerConfig: goRouter,
      debugShowCheckedModeBanner: false,
      restorationScopeId: 'app',
      onGenerateTitle: (BuildContext context) => 'My Shop'.hardcoded,
      theme: ThemeData(
        // * Use this to toggle Material 3 (defaults to true since Flutter 3.16)
        useMaterial3: true,
        primarySwatch: Colors.grey,
        textTheme: TextTheme(
          titleLarge: theme.textTheme.titleLarge!.copyWith(
            fontWeight: FontWeight.bold,
          ),
          titleMedium: theme.textTheme.titleMedium!.copyWith(
            fontWeight: FontWeight.bold,
          ),
          titleSmall: theme.textTheme.titleSmall!.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        appBarTheme: const AppBarTheme(
          // backgroundColor: Colors.black87,
          // foregroundColor: Colors.white,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black, // background (button) color
            foregroundColor: Colors.white, // foreground (text) color
          ),
        ),
      ),
    );
  }
}
