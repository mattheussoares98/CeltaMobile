import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/entities.dart';
import '../../providers/resource/resource.dart';
import '../../providers/user_session/user_session.dart';

part 'can_access_resource_state_controller.g.dart';

@Riverpod(keepAlive: true)
class CanAccessResourceStateController
    extends _$CanAccessResourceStateController {
  @override
  Future<bool> build(
    BsRoutine routine,
    BsResource resource,
    int enterpriseCode,
  ) async {
    final userSession = await ref.watch(userSessionProvider.future);

    final baseUrl = userSession!.enterprise.baseUrl!;
    final crossIdentity = userSession.user.CrossIdentity_Usuario!;

    final resourceRepository = ref.watch(soapResourceRepositoryProvider);

    return await resourceRepository.canAccessResource(
      resource: resource,
      routine: routine,
      baseUrl: baseUrl,
      crossIdentity: crossIdentity,
    );
  }
}
