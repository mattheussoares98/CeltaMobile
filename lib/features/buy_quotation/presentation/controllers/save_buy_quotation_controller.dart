import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/domain/entities/entities.dart';
import '../../../../core/presentation/controllers/app_usage/app_usage.dart';
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

      ref
          .read(appUsageStateControllerProvider.notifier)
          .addUsage(UsageType.insertUpdateBuyQuotation);

      await ref
          .read(soapInsertUpdateBuyQuotationRepositoryProvider)
          .insertUpdate(
            workingUrl: validatedUser!.enterprise!.workingUrl!,
            crossIdentity: validatedUser.user.CrossIdentity_Usuario!,
            buyQuotation: buyQuotation,
            now: DateTime.now(),
            observations: observations,
          );

      ref.invalidate(buyQuotationsStateControllerProvider(enterpriseCode));
      ref.invalidateSelf();
      saved = true;
    });
    return saved;
  }
}
