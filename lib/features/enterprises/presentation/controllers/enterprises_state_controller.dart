import 'dart:async';

import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/providers/providers.dart';
import '../../../../exceptions/exceptions.dart';
import '../../../../features/auth/presentation/controllers/controllers.dart';
import '../../../../core/domain/entities/entities.dart';

part 'enterprises_state_controller.g.dart';

@Riverpod(keepAlive: true)
class EnterprisesStateController extends _$EnterprisesStateController {
  @override
  Future<List<EnterpriseEntity>> build() async {
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

    final sessionAsync = ref.watch(userSessionProvider);
    final authAsync = ref.watch(authStateControllerProvider);

    if (sessionAsync.isLoading || authAsync.isLoading) {
      return [];
    }

    final baseUrl = sessionAsync.value?.baseUrl;
    final crossIdentity = authAsync.value?.CrossIdentity_Usuario;

    if (baseUrl == null ||
        baseUrl.isEmpty ||
        crossIdentity == null ||
        crossIdentity.isEmpty) {
      throw AppException(
        'URL ou CrossIdentity inválidos. Entre em contato com o suporte técnico'
            .hardcoded,
      );
    }

    return ref
        .watch(enterpriseRepositoryProvider)
        .getSoapEnterprises(url: baseUrl, crossIdentity: crossIdentity);
  }
}
