import 'package:celta_inventario/core/providers/ec_request_params/ec_request_params.dart';
import 'package:celta_inventario/features/customer_register/domain/entities/entities.dart';
import 'package:celta_inventario/features/customer_register/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'global_parameters_controller.g.dart';

@Riverpod(keepAlive: true)
class GlobalParametersController extends _$GlobalParametersController {
  @override
  FutureOr<BSFGlobalParametersEntity> build() async {
    final params = await ref.watch(ecRequestParamsProvider().future);
    return ref
        .read(ecGlobalParametersRepositoryProvider)
        .getGlobalParameters(params);
  }
}
