import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../domain/entities/entities.dart';
import '../user_session/user_session.dart';
import '../../../providers/supplier/supplier.dart';

part 'supplier_state_controller.g.dart';

@Riverpod(keepAlive: true)
class SupplierStateController extends _$SupplierStateController {
  @override
  FutureOr<List<SupplierEntity>?> build(SearchSupplierType searchType) async {
    return null;
  }

  Future<void> load(String searchValue) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final userSession = await ref.watch(validatedUserSessionProvider.future);
      return await ref
          .read(soapLoadSupplierRepositoryProvider)
          .load(
            workingUrl: userSession!.enterprise!.workingUrl!,
            crossIdentity: userSession.user.CrossIdentity_Usuario!,
            searchType: searchType,
            searchValue: searchValue,
          );
    });
  }
}
