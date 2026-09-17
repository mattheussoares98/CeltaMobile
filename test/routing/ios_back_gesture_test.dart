import 'package:celta_inventario/core/presentation/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  testWidgets('pushed nested route supports the iOS back gesture', (
    tester,
  ) async {
    final router = GoRouter(
      initialLocation: '/home',
      routes: [
        GoRoute(
          path: '/home',
          name: 'home',
          builder: (_, _) => const Scaffold(body: Text('Home')),
          routes: [
            GoRoute(
              path: ':enterpriseCode/search-products',
              name: 'searchProducts',
              builder: (_, _) => const Scaffold(body: Text('Search products')),
            ),
          ],
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: router,
        theme: AppTheme.themeData(ThemeData()),
      ),
    );
    await tester.pumpAndSettle();

    router.pushNamed('searchProducts', pathParameters: {'enterpriseCode': '1'});
    await tester.pumpAndSettle();
    expect(find.text('Search products'), findsOneWidget);
    final searchContext = tester.element(find.text('Search products'));
    expect(Theme.of(searchContext).platform, TargetPlatform.iOS);
    expect(
      Theme.of(searchContext)
          .pageTransitionsTheme
          .builders[TargetPlatform.iOS]
          .runtimeType
          .toString(),
      'CupertinoPageTransitionsBuilder',
    );
    expect(
      (ModalRoute.of(searchContext)! as PageRoute<void>).popGestureEnabled,
      isTrue,
    );
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget.runtimeType.toString().contains('CupertinoBackGesture'),
      ),
      findsOneWidget,
    );

    final gesture = await tester.startGesture(const Offset(5, 300));
    await gesture.moveBy(const Offset(500, 0));
    await tester.pump();
    expect(Navigator.of(searchContext).userGestureInProgress, isTrue);
    await gesture.up();
    await tester.pumpAndSettle();

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Search products'), findsNothing);
  }, variant: TargetPlatformVariant.only(TargetPlatform.iOS));
}
