import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:celta_inventario/core/providers/bs_version/bs_version.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';

part 'bs_version_state_controller.g.dart';

@riverpod
class BsVersionStateController extends _$BsVersionStateController {
  @override
  FutureOr<DateTime?> build() async {
    final userSession = await ref.watch(validatedUserSessionProvider.future);
    final workingUrl = userSession?.enterprise?.workingUrl;
    return await ref.read(soapBsVersionDatasourceProvider).get(workingUrl!);
  }
}
