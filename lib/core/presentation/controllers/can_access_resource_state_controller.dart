import 'package:celta_intelligence/core/providers/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../features/auth/presentation/controllers/controllers.dart';
import '../../domain/entities/entities.dart';

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

    final userEntity = await ref.watch(authStateControllerProvider.future);
    final baseUrl = userSession!.baseUrl!;
    final crossIdentity = userEntity!.CrossIdentity_Usuario!;

    final resourceRepository = ref.watch(soapResourceRepositoryProvider);

    return await resourceRepository.canAccessResource(
      resource: resource,
      routine: routine,
      baseUrl: baseUrl,
      crossIdentity: crossIdentity,
    );
  }
}
