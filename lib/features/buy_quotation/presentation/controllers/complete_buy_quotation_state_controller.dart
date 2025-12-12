import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/presentation/controllers/user_session/user_session.dart';
import '../../domain/entities/entities.dart';
import '../../providers.dart';

part 'complete_buy_quotation_state_controller.g.dart';

@riverpod
class CompleteBuyQuotationsStateController
    extends _$CompleteBuyQuotationsStateController {
  @override
  Future<BuyQuotationEntity> build(
    int enterpriseCode,
    String codeForFullSearch,
  ) async {
    final validatedUser = await ref.watch(validatedUserSessionProvider.future);

    if (codeForFullSearch == '0') {
      return BuyQuotationEntity.empty();
    }

    final response = await ref
        .read(soapLoadBuyQuotationsRepositoryProvider)
        .load(
          baseUrl: validatedUser!.enterprise!.baseUrl!,
          crossIdentity: validatedUser.user.CrossIdentity_Usuario!,
          enterpriseCode: enterpriseCode,
          codeForFullSearch: codeForFullSearch,
        );

    return response.first;
  }
}
