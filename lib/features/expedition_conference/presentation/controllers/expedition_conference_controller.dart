import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/presentation/controllers/user_session/user_session.dart';
import '../../domain/entities/entities.dart';
import '../../providers.dart';

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
    //TODO throw if return empty products

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
