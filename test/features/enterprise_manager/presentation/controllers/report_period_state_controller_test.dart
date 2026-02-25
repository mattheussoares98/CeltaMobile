// test/features/<...>/presentation/controllers/report_period_state_controller_test.dart

import 'dart:async';

import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/enterprise_manager/presentation/controllers/controllers.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Import your providers/controllers
import 'package:celta_inventario/core/presentation/controllers/app_usage/app_usage.dart';

/// A lightweight fake notifier to observe:
/// - how many times it was (re)created (as a proxy for invalidation/rebuild)
/// - whether `loadRemoteUsageReport` was called with the right dates
class FakeAppUsageStateController extends AppUsageStateController {
  FakeAppUsageStateController(this.onCreated);

  final void Function() onCreated;

  int loadCalls = 0;
  DateTime? lastStart;
  DateTime? lastEnd;

  @override
  FutureOr<List<AppUsageEntity>?> build() {
    // This runs when the provider is built/rebuilt.
    onCreated();
    // Return any valid initial state for your app.
    // If you have a specific state type, adapt this accordingly.
    return null;
  }

  @override
  Future<void> loadRemoteUsageReport({
    required DateTime start,
    required DateTime end,
  }) async {
    loadCalls++;
    lastStart = start;
    lastEnd = end;
  }
}

void main() {
  ProviderContainer makeContainer({
    required FakeAppUsageStateController Function() fakeFactory,
  }) {
    final container = ProviderContainer(
      retry: (retryCount, error) => null,
      overrides: [
        // Override the app usage provider with our fake notifier.
        appUsageStateControllerProvider.overrideWith(fakeFactory),
      ],
    );

    addTearDown(container.dispose);
    return container;
  }

  group('ReportPeriodStateController', () {
    test(
      'build returns current month range and triggers loadRemoteUsageReport',
      () async {
        int createdCount = 0;

        late FakeAppUsageStateController fake;
        final container = makeContainer(
          fakeFactory: () {
            fake = FakeAppUsageStateController(() => createdCount++);
            return fake;
          },
        );

        // Act
        final (start, end) = container.read(
          reportPeriodStateControllerProvider,
        );

        // Assert date range
        final now = DateTime.now();
        final expectedStart = DateTime(now.year, now.month, 1);
        final expectedEnd = DateTime(now.year, now.month + 1, 0);

        expect(start, expectedStart);
        expect(end, expectedEnd);

        // Assert it called remote load once with the same values
        expect(fake.loadCalls, 1);
        expect(fake.lastStart, expectedStart);
        expect(fake.lastEnd, expectedEnd);

        // AppUsage provider should have been created at least once due to the read in build()
        expect(createdCount, 1);
      },
    );

    test(
      'update does not invalidate appUsage provider when dates do not change',
      () async {
        int createdCount = 0;

        late FakeAppUsageStateController fake;
        final container = makeContainer(
          fakeFactory: () {
            fake = FakeAppUsageStateController(() => createdCount++);
            return fake;
          },
        );

        final initial = container.read(reportPeriodStateControllerProvider);
        expect(createdCount, 1);

        // Same values -> should NOT invalidate
        container
            .read(reportPeriodStateControllerProvider.notifier)
            .update(startDate: initial.$1, endDate: initial.$2);

        // Force a read of appUsage notifier again.
        // If it was invalidated, it would rebuild and increment createdCount.
        container.read(appUsageStateControllerProvider);

        expect(
          createdCount,
          1,
          reason:
              'Should not rebuild appUsage provider if dates are unchanged.',
        );
        expect(
          fake.loadCalls,
          1,
          reason:
              'No extra load should happen from just updating with same dates.',
        );
      },
    );

    test('update invalidates appUsage provider when dates change', () async {
      int createdCount = 0;

      final fakes = <FakeAppUsageStateController>[];

      final container = makeContainer(
        fakeFactory: () {
          final f = FakeAppUsageStateController(() => createdCount++);
          fakes.add(f);
          return f;
        },
      );

      final (start, end) = container.read(reportPeriodStateControllerProvider);
      expect(createdCount, 1);

      // Change start date -> should invalidate appUsage provider
      final newStart = start.subtract(const Duration(days: 1));

      container
          .read(reportPeriodStateControllerProvider.notifier)
          .update(startDate: newStart);

      // Reading appUsage provider after invalidation forces rebuild
      container.read(appUsageStateControllerProvider);

      expect(
        createdCount,
        2,
        reason:
            'Changing dates should invalidate and rebuild appUsage provider.',
      );

      // Also confirm the ReportPeriodStateController state changed
      final updated = container.read(reportPeriodStateControllerProvider);
      expect(updated.$1, newStart);
      expect(updated.$2, end);
    });
  });
}
