import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/core/providers/resource/resource.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'can_access_resource_state_controller.g.dart';

@Riverpod(keepAlive: true)
class CanAccessResourceStateController
    extends _$CanAccessResourceStateController {
  @override
  Future<bool> build(BsRoutine routine, BsResource resource) async {
    ref.cache(60);
    final userSession = await ref.watch(validatedUserSessionProvider.future);

    final workingUrl = userSession!.enterprise!.workingUrl!;
    final crossIdentity = userSession.user.CrossIdentity_Usuario!;

    final resourceRepository = ref.watch(soapResourceRepositoryProvider);

    return await resourceRepository.canAccessResource(
      resource: resource,
      routine: routine,
      workingUrl: workingUrl,
      crossIdentity: crossIdentity,
    );
  }
}
