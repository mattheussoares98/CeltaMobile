import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/features/process_authorization/domain/entities/entities.dart';
import 'package:celta_inventario/features/process_authorization/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'process_authorization_errors_state_controller.g.dart';

@Riverpod(keepAlive: true)
class ProcessAuthorizationErrorsStateController
    extends _$ProcessAuthorizationErrorsStateController {
  @override
  FutureOr<dynamic> build({
    required int enterpriseCode,
    required int customerCode,
    required int saleRequestCode,
    required TypeAccordingToTheCode errorType,
  }) async {
    //TODO create a Category that will call the respective repository and use the respective state
    final validatedUser = await ref.watch(validatedUserSessionProvider.future);

    final repository = ref.read(ecProcessAuthorizationRepositoryProvider);
    final ecParams = EcRequestParams(
      workingUrl: validatedUser!.enterprise!.workingUrl!,
      user: validatedUser.user.name!,
      accessKey: validatedUser.user.AccessKey!,
    );

    return repository.getSaleRequestErrors(
      ecParams,
      enterpriseCode: enterpriseCode,
      saleRequestCode: saleRequestCode,
      customerCode: customerCode,
      errorType: errorType == TypeAccordingToTheCode.saleRequestDiscount
          ? SaleRequestErrorType.discount
          : SaleRequestErrorType.lucrativity,
    );
  }
}
