import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../providers/bs_version/bs_version.dart';
import '../user_session/user_session.dart';

part 'bs_version_state_controller.g.dart';

@riverpod
class BsVersionStateController extends _$BsVersionStateController {
  @override
  FutureOr<DateTime?> build() async {
    final workingUrl = await ref.watch(
      validatedUserSessionProvider.selectAsync(
        (s) => s?.enterprise?.workingUrl,
      ),
    );
    return await ref.read(soapBsVersionDatasourceProvider).get(workingUrl!);
  }
}
