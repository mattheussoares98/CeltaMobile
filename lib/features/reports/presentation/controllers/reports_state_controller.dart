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
          baseUrl: validatedUser!.enterprise!.baseUrl!,
          crossIdentity: validatedUser.user.CrossIdentity_Usuario!,
        );
  }
}
