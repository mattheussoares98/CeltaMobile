import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../features/enterprises/presentation/controllers/controllers.dart';
import '../../../../../core/domain/entities/entities.dart';
import '../../../../core/presentation/controllers/user_session/user_session.dart';
import '../../../settings/presentation/controllers/controllers.dart';
import '../../providers.dart';

part 'products_state_controller.g.dart';

@riverpod
class ProductsStateController extends _$ProductsStateController {
  @override
  Future<List<ProductEntity>> build({
    required int enterpriseOriginCode,
    required int enterpriseDestinyCode,
    required int requestTypeCode,
  }) async {
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

  Future<void> loadProducts({required String searchValue}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final userSession = await ref.watch(validatedUserSessionProvider.future);
      final selectedEnterprise = ref.read(
        selectedEnterpriseStateControllerProvider,
      );

      final baseUrl = userSession!.enterprise!.baseUrl!;
      final crossIdentity = userSession.user.CrossIdentity_Usuario!;

      final settings = await ref.read(
        appSettingsStateControllerProvider.future,
      );
      final searchType =
          settings?.searchPreference.searchType ?? SearchType.dynamic;

      final products = await ref
          .read(soapLoadProductByRequestTypeRepositoryProvider)
          .load(
            baseUrl: baseUrl,
            crossIdentity: crossIdentity,
            enterpriseOriginCode: enterpriseOriginCode,
            enterpriseDestinyCode: enterpriseDestinyCode,
            requestTypeCode: requestTypeCode,
            enterpriseEntity: selectedEnterprise!,
            searchValue: searchValue,
            searchType: searchType,
          );

      return products;
    });
  }
}
