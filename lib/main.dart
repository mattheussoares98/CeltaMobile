import 'package:celta_inventario/app.dart';
import 'package:celta_inventario/exceptions/error_logger.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// ignore:depend_on_referenced_packages
import 'package:flutter_web_plugins/url_strategy.dart';

void main() async {
  await initApp();

  // turn off the # in the URLs on the web
  usePathUrlStrategy();
  // * Register error handlers. For more info, see:
  // * https://docs.flutter.dev/testing/errors
  // * Create ProviderContainer with any required overrides
  final container = ProviderContainer(
    retry: (retryCount, error) => null,
    overrides: [],
    observers: [/* AsyncErrorLogger() */],
  );
  // * Initialize CartSyncService to start the listener
  // final errorLogger = container.read(errorLoggerProvider);
  // * Register error handlers. For more info, see:
  // * https://docs.flutter.dev/testing/errors
  // registerErrorHandlers(errorLogger);
  // * Entry point of the app
  runApp(UncontrolledProviderScope(container: container, child: const MyApp()));
}

void registerErrorHandlers(ErrorLogger errorLogger) {
  // * Show some error UI if any uncaught exception happens
  FlutterError.onError = (FlutterErrorDetails details) {
    if (details.context != null) {
      errorLogger.logError(
        details.context!,
        null,
        reason: '🔴 Flutter Error Context (Widget/Position)',
      );
    }
    FlutterError.presentError(details);
    errorLogger.logError(
      details.exception,
      details.stack,
      reason:
          'Starting the LOG exception from ErrorLogger - FlutterError.onError',
    );
  };
  // * Handle errors from the underlying platform/OS
  PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
    errorLogger.logError(
      error,
      stack,
      reason:
          'Starting the LOG exception from ErrorLogger - PlatformDispatcher.instance.onError',
    );
    return true;
  };
  // * Show some error UI when any widget in the app fails to build
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Builder(
          builder: (context) => Text(context.l10n.anErrorOccurred),
        ),
      ),
      body: Center(child: Text(details.toString())),
    );
  };
}
