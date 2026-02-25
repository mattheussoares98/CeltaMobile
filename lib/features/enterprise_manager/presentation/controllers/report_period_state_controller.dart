import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/presentation/controllers/app_usage/app_usage.dart';

part 'report_period_state_controller.g.dart';

@Riverpod(keepAlive: true)
class ReportPeriodStateController extends _$ReportPeriodStateController {
  @override
  (DateTime startDate, DateTime endDate) build() {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, 1);
    final end = DateTime(now.year, now.month + 1, 0);

    ref
        .read(appUsageStateControllerProvider.notifier)
        .loadRemoteUsageReport(start: start, end: end);

    return (start, end);
  }

  void update({DateTime? startDate, DateTime? endDate}) {
    final updatedDate =
        (startDate != null && startDate != state.$1) ||
        (endDate != null && endDate != state.$2);

    state = (startDate ?? state.$1, endDate ?? state.$2);
    if (updatedDate) {
      ref.invalidate(appUsageStateControllerProvider);
    }
  }
}
