import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'report_period_state_controller.g.dart';

@Riverpod(keepAlive: true)
class ReportPeriodStateController extends _$ReportPeriodStateController {
  @override
  DateTime build() {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month);
    //!only the month matters because save only the year and month on the database

    return start;
  }

  void update({int? startMonth, int? startYear}) {
    state = DateTime(startYear ?? state.year, startMonth ?? state.month);
  }
}
