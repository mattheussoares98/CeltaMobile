import 'package:flutter/material.dart';

import '../core/domain/entities/entities.dart';
import '../core/infraestructure/infrastructure.dart';

class CrashlyticsRouteObserver extends RouteObserver<PageRoute<dynamic>> {
  final ICrashlyticsService _service;

  CrashlyticsRouteObserver(this._service);

  void _logScreen(Route<dynamic>? route) {
    if (route is PageRoute) {
      final screenName = route.settings.name;
      if (screenName != null) {
        // Use the service we passed in
        _service.setCustomKeys([
          CrashlyticsCustomKeyEntity(key: 'current_screen', value: screenName),
        ]);
      }
    }
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _logScreen(route);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    _logScreen(previousRoute);
  }
}
