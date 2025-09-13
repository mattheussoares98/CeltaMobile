import 'dart:async';

import 'package:celta_intelligence/features/enterprises/presentation/controllers/controllers.dart';
import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/data/datasource/datasource.dart';
import '../../../../core/providers/providers.dart';
import '../../../../features/auth/presentation/controllers/controllers.dart';
import '../../../../core/domain/entities/entities.dart';

part 'products_state_controller.g.dart';

@riverpod
class ProductsStateController extends _$ProductsStateController {
  @override
  Future<List<ProductEntity>> build() async {
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
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final user = await ref.read(authStateControllerProvider.future);
      final userSession = await ref.read(userSessionProvider.future);
      final enterprises = await ref.read(
        enterprisesStateControllerProvider.future,
      );
      final enterpriseEntity = enterprises.firstWhere(
        (e) => e.Code == enterpriseCode,
      );

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
            enterpriseEntity: enterpriseEntity,
          );

      return products;
    });
  }
}
