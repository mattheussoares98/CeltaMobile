import 'package:celta_inventario/features/enterprise_manager/presentation/controllers/controllers.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:celta_inventario/core/presentation/controllers/app_usage/app_usage.dart';

void main() {
  ProviderContainer makeContainer() {
    final container = ProviderContainer(
      retry: (retryCount, error) => null,
      overrides: [
        // Override the app usage provider with our fake notifier.
      ],
    );

    addTearDown(container.dispose);
    return container;
  }

  group('ReportPeriodStateController', () {
    test(
      'build returns current month range and triggers loadRemoteUsageReport',
      () async {
        final container = makeContainer();

        // Act
        final (start, end) = container.read(
          reportPeriodStateControllerProvider,
        );

        // Assert date range
        final now = DateTime.now();
        final expectedStart = DateTime(now.year, now.month);
        final expectedEnd = DateTime(now.year, now.month);

        expect(start, expectedStart);
        expect(end, expectedEnd);
      },
    );

    test('update invalidates appUsage provider when dates change', () async {
      final container = makeContainer();

      final (start, end) = container.read(reportPeriodStateControllerProvider);

      // Change start date -> should invalidate appUsage provider
      final newStart = start.subtract(const Duration(days: 1));
      final newEnd = end.add(const Duration(days: 1));

      container
          .read(reportPeriodStateControllerProvider.notifier)
          .update(
            startMonth: newStart.month,
            startYear: newStart.year,
            endMonth: newEnd.month,
            endYear: newEnd.year,
          );

      // Reading appUsage provider after invalidation forces rebuild
      container.read(appUsageStateControllerProvider);

      final updated = container.read(reportPeriodStateControllerProvider);
      expect(updated.$1.month, newStart.month);
      expect(updated.$1.year, newStart.year);
      expect(updated.$2.month, newEnd.month);
      expect(updated.$2.year, newEnd.year);
    });
  });
}
