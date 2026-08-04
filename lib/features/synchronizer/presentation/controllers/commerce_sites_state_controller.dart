// lib/features/synchronizer/presentation/controllers/commerce_sites_state_controller.dart
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/core/providers/ec_request_params/ec_request_params.dart';
import 'package:celta_inventario/features/synchronizer/domain/entities/entities.dart';
import 'package:celta_inventario/features/synchronizer/providers.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'commerce_sites_state_controller.g.dart';

@riverpod
class CommerceSitesStateController extends _$CommerceSitesStateController {
  @override
  FutureOr<List<EcCommerceSiteEntity>> build(int enterpriseCode) async {
    ref.cache(60);

    await ref.watch(validatedUserSessionProvider.future);
    final repository = ref.read(ecCommerceSiteRepositoryProvider);
    final ecParams = await ref.watch(ecRequestParamsProvider().future);

    return await repository.getCommerceSites(ecParams, enterpriseCode);
  }
}
