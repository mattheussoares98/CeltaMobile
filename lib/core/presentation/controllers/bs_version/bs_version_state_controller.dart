import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../providers/bs_version/bs_version.dart';
import '../user_session/user_session.dart';

part 'bs_version_state_controller.g.dart';

@Riverpod(keepAlive: true)
class BsVersionStateController extends _$BsVersionStateController {
  @override
  FutureOr<DateTime?> build() async {
    final validatedUserSession = await ref.watch(
      validatedUserSessionProvider.future,
    );
    return await ref
        .watch(soapBsVersionDatasourceProvider)
        .get(validatedUserSession!.enterprise!.workingUrl!);
  }
}
