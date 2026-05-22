import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/features/expedition_conference/domain/entities/entities.dart';
import 'package:celta_inventario/features/expedition_conference/providers.dart';

part 'expedition_conference_controller.g.dart';

@riverpod
class ExpeditionConferenceController extends _$ExpeditionConferenceController {
  @override
  FutureOr<ExpeditionConferenceState> build(int expeditionControlCode) async {
    final userSession = await ref.watch(validatedUserSessionProvider.future);

    final initialProducts = await ref
        .read(soapLoadPendingProductsRepositoryProvider)
        .load(
          workingUrl: userSession!.enterprise!.workingUrl!,
          crossIdentity: userSession.user.CrossIdentity_Usuario!,
          expeditionControlCode: expeditionControlCode,
        );

    return ExpeditionConferenceState(
      initialProducts: initialProducts,
      pendingQuantities: {
        for (var p in initialProducts) p.ProductPackingCode: p.Quantity,
      },
      scannedQuantities: const {},
    );
  }

  void updateState(ExpeditionConferenceState state) =>
      this.state = AsyncValue.data(state);
}
