import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../core/presentation/controllers/user_session/user_session.dart';
import '../core/providers/services/services.dart';
import '../features/enterprise_manager/presentation/controllers/controllers.dart';
import '../utils/utils.dart';
import 'not_found_page.dart';
import 'routes/routes.dart';

part 'app_router.g.dart';

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
  final userSessionBridge = Bridge<Object?>();

  ref.listen<AsyncValue<Object?>>(
    authManagerStateProvider,
    (prev, next) => enterpriseManagerBridge.value = next.value,
    fireImmediately: true,
  );

  ref.listen<AsyncValue<Object?>>(
    userSessionProvider,
    (prev, next) => userSessionBridge.value = next.value,
    fireImmediately: true,
  );

  return GoRouter(
    initialLocation: '/splash',
    debugLogDiagnostics: false,
    observers: [
      CrashlyticsRouteObserver(ref.watch(crashlyticsServiceProvider)),
    ],
    refreshListenable: Listenable.merge([
      enterpriseManagerBridge,
      userSessionBridge,
    ]),
    redirect: (context, state) {
      final bool isMobileWeb =
          kIsWeb &&
          (defaultTargetPlatform == TargetPlatform.iOS ||
              defaultTargetPlatform == TargetPlatform.android);

      final bool isAlreadyOnDownloadPage = state.matchedLocation.contains(
        '/download-app',
      );

      if (isMobileWeb && !isAlreadyOnDownloadPage) {
        debugPrint('System: Mobile Web detected. Redirecting...');
        return '/download-app';
      }

      final isLoggingIn = state.matchedLocation.contains('/auth');
      final isInSplash = state.matchedLocation.contains('/splash');
      final isManagingEnterprise = state.matchedLocation.contains(
        'enterprise-manager',
      );

      if (isInSplash || isManagingEnterprise) {
        return null;
      }

      final userSessionState = ref.read(userSessionProvider);
      if (userSessionState.isLoading) {
        return isInSplash ? null : '/splash';
      }

      final isLogged =
          userSessionState.value?.user.CrossIdentity_Usuario != null;

      if (isLoggingIn && isLogged) {
        return '/splash'; //there treat if goes to home or auth page
      } else if (!isLoggingIn && !isLogged) {
        return '/splash'; //there treat if goes to home or auth page
      }

      return null; // No redirection needed
    },
    routes: [
      authRoute(),
      downloadAppRoute(),
      enterpriseManagerRoute(enterpriseManagerBridge),
      homeRoute([
        adjustSalePriceProducts([adjustSalePrice()]),
        adjustStocksRoute(),
        buyQuotationsRoute([buyQuotationInsertUpdateRoute()]),
        buyRequestRoute(),
        competingPricesResearchsRoute([
          concurrentsRoute([competingPricesProductsRoute()]),
        ]),
        customerRegisterRoute(),
        expeditionConferenceDocumentsRoute([
          expeditionConferenceProductsRoute(),
        ]),
        inventoryFrozenProcessesRoute([
          inventoryCountingsRoute(),
          inventoryProductsRoute(),
        ]),
        transferRequestRquestsTypesRoute([
          originEnterprisesRoute([
            destinyEnterprisesRoute([productsManagementRoute()]),
          ]),
        ]),
        receiptsRoute([
          productsReceiptRoute([productsNotFoundRoute()]),
        ]),
        reportsRoute(),
        saleRequestRequestsTypesRoute([saleRequestRoute()]),
        searchProductsRoute(),
        shallowSearchProductsRoute(),
        stockReplacementRoute(),
        transferBetweenStocksRoute(),
        pdfViewerRoute(),
      ]),
      splashRoute(),
    ],

    errorBuilder: (context, state) => const NotFoundPage(),
  );
}
