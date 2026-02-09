import 'dart:math';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// PERFORMANCE: Using a NavigatorObserver to track the current page
/// centrally. This avoids manual logging in every widget.
class CrashlyticsRouteObserver extends NavigatorObserver {
  static String? _currentRoute;

  /// Returns the last recorded route name.
  static String get currentRoute => _currentRoute ?? 'Unknown Route';

  bool get _isSupported {
    if (kIsWeb) return false;
    return defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.android;
  }

  void _updateRoute(Route<dynamic>? route) {
    if (!_isSupported) return;

    final traceId = Random.secure().nextDouble();

    final name = route?.settings.name;
    if (name != null) {
      _currentRoute = name;
      // PERFORMANCE: setCustomKey is optimized by the Firebase SDK to be
      // extremely lightweight, as it only writes to a local key-value store.
      //generate trace IDs in the logs, which helps you distinguish between different navigation attempts during the same session.
      FirebaseCrashlytics.instance.setCustomKey('last_visited_page', name);

      // We also add a log breadcrumb for the crash timeline
      FirebaseCrashlytics.instance.log(
        'Navigation to: $name [Trace: $traceId]',
      );
    }
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _updateRoute(route);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    _updateRoute(previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _updateRoute(newRoute);
  }
}
