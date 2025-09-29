import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:go_router/go_router.dart';

import '../features/enterprise_manager/presentation/controllers/controllers.dart';
import 'not_found_page.dart';
import 'routes/routes.dart';

part 'app_router.g.dart';

enum AppRoute {
  auth('Autenticação'),
  adjustSalePrice('Alterar preços'),
  adjustSalePriceProducts('Alterar preços'),
  adjustStocks('Ajustar estoque'),
  createEnterprise('Criar empresa'),
  enterpriseManager('Gerenciamento de empresas'),
  enterpriseManagerAuth('Autenticação'),
  enterpriseManagerChangeModulesPermissions('Permissões de módulos'),
  enterpriseManagerDash('Dashboard'),
  enterprises('Empresas'),
  home('Home'),
  splash('Splash');

  final String module;
  const AppRoute(this.module);
}

class Bridge<T> extends ChangeNotifier {
  T? _value;
  T? get value => _value;
  set value(T? v) {
    if (!identical(v, _value)) {
      _value = v;
      notifyListeners();
    }
  }
}

@Riverpod(keepAlive: true)
GoRouter goRouter(Ref ref) {
  final enterpriseManagerBridge = Bridge<Object?>();

  ref.listen<AsyncValue<Object?>>(
    authManagerStateProvider,
    (prev, next) => enterpriseManagerBridge.value = next.valueOrNull,
    fireImmediately: true,
  );

  return GoRouter(
    initialLocation: '/splash',
    debugLogDiagnostics: false,
    refreshListenable: Listenable.merge([enterpriseManagerBridge]),
    routes: [
      authRoute(),
      enterpriseManagerRoute(enterpriseManagerBridge),
      homeRoute([
        adjustSalePriceProducts([adjustSalePrice()]),
        adjustStocksRoute(),
      ]),
      splashRoute(),
    ],

    errorBuilder: (context, state) => const NotFoundPage(),
  );
}
