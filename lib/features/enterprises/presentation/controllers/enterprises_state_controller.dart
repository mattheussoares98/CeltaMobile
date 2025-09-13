import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/providers/providers.dart';
import '../../../../features/auth/presentation/controllers/controllers.dart';
import '../../../../core/domain/entities/entities.dart';

part 'enterprises_state_controller.g.dart';

@riverpod
class EnterprisesStateController extends _$EnterprisesStateController {
  @override
  Future<List<EnterpriseEntity>> build() async {
    Timer? timer;
    final link = ref.keepAlive();
    ref.onCancel(() {
      timer = Timer(const Duration(seconds: 10), () {
        link.close();
      });
    });
    ref.onResume(() {
      timer?.cancel();
    });
    ref.onDispose(() {
      timer?.cancel();
    });

    final session = ref.watch(userSessionProvider);
    final auth = ref.watch(authStateControllerProvider);

    final baseUrl = session.value?.baseUrl;
    final crossIdentity = auth.value?.CrossIdentity_Usuario;

    if (baseUrl == null ||
        baseUrl.isEmpty ||
        crossIdentity == null ||
        crossIdentity.isEmpty) {
      return [];
    }

    return ref
        .watch(enterpriseRepositoryProvider)
        .getSoapEnterprises(url: baseUrl, crossIdentity: crossIdentity);
  }
}
