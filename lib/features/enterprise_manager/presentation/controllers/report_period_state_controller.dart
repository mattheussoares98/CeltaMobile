import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'report_period_state_controller.g.dart';

@Riverpod(keepAlive: true)
class ReportPeriodStateController extends _$ReportPeriodStateController {
  @override
  (DateTime startDate, DateTime endDate) build() {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month);
    //!only the month matters because save only the year and month on the database

    return (start, start);
  }

  void update({int? startMonth, int? startYear, int? endMonth, int? endYear}) {
    final newStartDate = DateTime(
      startYear ?? state.$1.year,
      startMonth ?? state.$1.month,
    );
    final newEndDate = DateTime(
      endYear ?? state.$2.year,
      endMonth ?? state.$2.month,
    );

    state = (newStartDate, newEndDate);
  }
}
