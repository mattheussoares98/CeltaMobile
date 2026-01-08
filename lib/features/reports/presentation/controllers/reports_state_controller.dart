import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/presentation/controllers/user_session/user_session.dart';
import '../../domain/entities/entities.dart';
import '../../providers.dart';

part 'reports_state_controller.g.dart';

@Riverpod(keepAlive: true)
class ReportsStateController extends _$ReportsStateController {
  @override
  FutureOr<List<ReportScheduleEntity>> build() async {
    final validatedUser = await ref.watch(validatedUserSessionProvider.future);

    return ref
        .read(soapLoadReportsRepositoryProvider)
        .load(
          workingUrl: validatedUser!.enterprise!.workingUrl!,
          crossIdentity: validatedUser.user.CrossIdentity_Usuario!,
        );
  }

  void updateExecutionDate(int reportScheduleCode) {
    final currentState = state.value;
    if (currentState == null) return;

    final reportIndex = state.value!.indexWhere(
      (e) => e.Code == reportScheduleCode,
    );

    final oldReport = state.value![reportIndex].copyWith(
      LastExecutionDate: DateTime.now(),
    );

    final updatedList = [...state.value!];
    updatedList[reportIndex] = oldReport;

    state = AsyncData(updatedList);
  }
}
