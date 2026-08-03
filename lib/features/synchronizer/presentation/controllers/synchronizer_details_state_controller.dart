import 'dart:async';

import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/resource/resource.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/core/providers/ec_request_params/ec_request_params.dart';
import 'package:celta_inventario/exceptions/exceptions.dart';
import 'package:celta_inventario/features/synchronizer/domain/entities/entities.dart';
import 'package:celta_inventario/features/synchronizer/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/synchronizer/providers.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'synchronizer_details_state_controller.g.dart';

@riverpod
class SynchronizerDetailsStateController
    extends _$SynchronizerDetailsStateController {
  @override
  FutureOr<SynchronizerErrorDetailsEntity> build(String errorKey) async {
    ref.cache();

    await ref.watch(validatedUserSessionProvider.future);

    final canAccess = ref.watch(
      canAccessResourceStateControllerProvider(
        BsRoutine.generic,
        BsResource.synchronizer,
      ),
    );

    if (canAccess.value != true) {
      throw AppException(
        'Usuário sem permissão para acessar este módulo'.hardcoded,
      );
    }

    final repository = ref.read(ecSynchronizerRepositoryProvider);
    final ecParams = await ref.watch(ecRequestParamsProvider().future);

    unawaited(
      ref
          .read(synchronizerCountStateControllerProvider.notifier)
          .refreshSilently(),
    );

    return await repository.searchByKey(ecParams, errorKey);
  }
}
