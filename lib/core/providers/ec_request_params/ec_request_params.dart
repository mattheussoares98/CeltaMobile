import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ec_request_params.g.dart';

@riverpod
FutureOr<EcRequestParams> ecRequestParams(
  Ref ref, {
  int? actualPage,
  int? recordsByPage,
}) async {
  final validatedUser = await ref.watch(validatedUserSessionProvider.future);
  return EcRequestParams(
    workingUrl: validatedUser!.enterprise!.workingUrl!,
    user: validatedUser.user.name!,
    accessKey: validatedUser.user.AccessKey!,
    actualPage: actualPage,
    recordsByPage: recordsByPage,
  );
}
