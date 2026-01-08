import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/presentation/controllers/user_session/user_session.dart';
import '../../../../exceptions/exceptions.dart';
import '../../providers.dart';
import 'controller.dart';

part 'save_buy_quotation_controller.g.dart';

@riverpod
class SaveBuyQuotationController extends _$SaveBuyQuotationController {
  @override
  Future<void> build(int enterpriseCode, String code) async {}

  Future<bool> save(String observations) async {
    bool saved = false;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final validatedUser = await ref.watch(
        validatedUserSessionProvider.future,
      );
      final buyQuotation = await ref.read(
        completeBuyQuotationsStateControllerProvider(
          enterpriseCode,
          code,
        ).future,
      );

      if (buyQuotation.Buyer == null) {
        throw AppException('O comprador deve ser informado');
      } else if (buyQuotation.Enterprises == null ||
          buyQuotation.Enterprises!.isEmpty) {
        throw AppException('Ao menos uma empresa deve ser informada');
      } else if (buyQuotation.Products == null ||
          buyQuotation.Products!.isEmpty) {
        throw AppException('Ao menos um produto deve ser informado');
      }

      await ref
          .read(soapInsertUpdateBuyQuotationRepositoryProvider)
          .insertUpdate(
            urlInUse: validatedUser!.enterprise!.urlInUse!,
            crossIdentity: validatedUser.user.CrossIdentity_Usuario!,
            buyQuotation: buyQuotation,
            now: DateTime.now(),
            observations: observations,
          );

      ref.invalidateSelf();
      ref.invalidate(buyQuotationsStateControllerProvider(enterpriseCode));
      saved = true;
      return;
    });
    return saved;
  }
}
