import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/presentation/controllers/user_session/user_session.dart';
import '../../../../core/providers/enterprise/enterprise.dart';
import '../../../../features/enterprises/presentation/controllers/controllers.dart';
import '../../../../core/domain/entities/entities.dart';

part 'enterprises_state_controller.g.dart';

@Riverpod(keepAlive: true)
class EnterprisesStateController extends _$EnterprisesStateController {
  @override
  Future<List<EnterpriseEntity>> build(int? enterpriseCode) async {
    // Timer? timer;
    // final link = ref.keepAlive();
    // ref.onCancel(() {
    //   timer = Timer(const Duration(seconds: 10), () {
    //     link.close();
    //   });
    // });
    // ref.onResume(() {
    //   timer?.cancel();
    // });
    // ref.onDispose(() {
    //   timer?.cancel();
    // });

    final sessionAsync = ref.watch(validatedUserSessionProvider);

    if (sessionAsync.isLoading) {
      return [];
    }

    final baseUrl = sessionAsync.value!.enterprise!.baseUrl!;
    final crossIdentity = sessionAsync.value!.user.CrossIdentity_Usuario!;

    final enterprises = await ref
        .watch(enterpriseRepositoryProvider)
        .getSoapEnterprises(
          url: baseUrl,
          crossIdentity: crossIdentity,
          enterpriseOriginCode: enterpriseCode,
        );

    if (enterprises.isNotEmpty) {
      ref
          .read(selectedEnterpriseStateControllerProvider.notifier)
          .selectEnterprise(enterprises.first);
    }

    return enterprises;
  }
}
