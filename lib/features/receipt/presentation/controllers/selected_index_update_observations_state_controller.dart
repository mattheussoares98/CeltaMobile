import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/features/receipt/providers.dart';
import 'package:celta_inventario/features/receipt/presentation/controllers/controllers.dart';

part 'selected_index_update_observations_state_controller.g.dart';

@riverpod
class SelectedIndexUpdateObservationsStateController
    extends _$SelectedIndexUpdateObservationsStateController {
  @override
  FutureOr<int?> build() async {
    return null;
  }

  void updateSelectedIndex(int index) {
    if (state.value == index) {
      state = const AsyncValue.data(null);
    } else {
      state = AsyncValue.data(index);
    }
  }

  Future<void> updateObservations({
    required int enterpriseCode,
    required String observations,
    required int CodigoInterno_ProcRecebDoc,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final validatedUser = await ref.watch(
        validatedUserSessionProvider.future,
      );

      await ref
          .read(soapUpdateObservationsDatasourceProvider)
          .update(
            workingUrl: validatedUser!.enterprise!.workingUrl!,
            crossIdentity: validatedUser.user.CrossIdentity_Usuario!,
            CodigoInterno_ProcRecebDoc: CodigoInterno_ProcRecebDoc,
            observations: observations,
          );

      ref
          .read(receiptsStateControllerProvider(enterpriseCode).notifier)
          .updateObservationsLocally(observations, CodigoInterno_ProcRecebDoc);
      return null;
    });
  }
}
