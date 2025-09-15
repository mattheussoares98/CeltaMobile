import 'dart:async';

import 'package:celta_intelligence/features/enterprises/presentation/controllers/controllers.dart';
import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/data/datasource/datasource.dart';
import '../../../../core/providers/providers.dart';
import '../../../../features/auth/presentation/controllers/controllers.dart';
import '../../../../core/domain/entities/entities.dart';

part 'search_products_state_controller.g.dart';

@riverpod
class SearchProductsStateController extends _$SearchProductsStateController {
  @override
  Future<List<ProductEntity>> build(int enterpriseCode) async {
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

  Future<void> loadProducts({
    required String searchValue,
    required int enterpriseCode,
    required EnterpriseEntity? selectedEnterprise,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final user = await ref.read(authStateControllerProvider.future);
      final userSession = await ref.read(userSessionProvider.future);

      late EnterpriseEntity enterpriseEntity;

      if (selectedEnterprise == null) {
        final enterprises = await ref.read(
          enterprisesStateControllerProvider.future,
        );
        enterpriseEntity = enterprises.firstWhere(
          (e) => e.Code == enterpriseCode,
        );
      }

      final baseUrl = userSession?.baseUrl;
      final crossIdentity = user?.CrossIdentity_Usuario;
      if (baseUrl == null ||
          baseUrl.isEmpty ||
          crossIdentity == null ||
          crossIdentity.isEmpty) {
        throw Exception(
          'URL ou CrossIdentity nulos. Entre em contato com o suporte técnico e avise sobre esse problema'
              .hardcoded,
        );
      }

      final products = await ref
          .read(soapProductsRepositoryProvider)
          .getProductsJson(
            baseUrl: baseUrl,
            searchValue: searchValue,
            crossIdentity: crossIdentity,
            routine: Routine.adjustSalePrice,
            searchType: SearchType.dynamic,
            enterpriseCodes: [enterpriseCode],
            enterpriseEntity: selectedEnterprise ?? enterpriseEntity,
          );

      return products;
    });
  }
}
