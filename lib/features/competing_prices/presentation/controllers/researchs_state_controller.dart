import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/presentation/controllers/user_session/user_session.dart';
import '../../../enterprises/presentation/controllers/controllers.dart';
import '../../domain/entities/entities.dart';
import '../../providers/providers.dart';

part 'researchs_state_controller.g.dart';

@riverpod
class ResearchsStateController extends _$ResearchsStateController {
  @override
  FutureOr<List<ResearchEntity>> build() async {
    Timer? timer;
    final link = ref.keepAlive();
    ref.onCancel(() {
      timer = Timer(const Duration(seconds: 20), () {
        link.close();
      });
    });
    ref.onResume(() {
      timer?.cancel();
    });
    ref.onDispose(() {
      timer?.cancel();
    });

    return [];
  }

  Future<void> load(String? searchValue) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(soapLoadResearchsRepositoryProvider);
      final validatedUserSession = await ref.watch(
        validatedUserSessionProvider.future,
      );
      final selectedEnterprise = ref.watch(
        selectedEnterpriseStateControllerProvider,
      );

      final researchs = await repository.load(
        crossIdentity: validatedUserSession!.user.CrossIdentity_Usuario!,
        baseUrl: validatedUserSession.enterprise!.baseUrl!,
        enterpriseCode: selectedEnterprise!.Code!,
        searchValue: searchValue,
      );

      return researchs;
    });
  }
}
