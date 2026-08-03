import 'dart:async';

import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/features/buy_quotation/domain/entities/entities.dart';
import 'package:celta_inventario/features/buy_quotation/providers.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'buy_quotations_state_controller.g.dart';

@riverpod
class BuyQuotationsStateController extends _$BuyQuotationsStateController {
  @override
  Future<List<BuyQuotationEntity>> build(int enterpriseCode) async {
    ref.cache();

    final validatedUser = await ref.watch(validatedUserSessionProvider.future);

    return await ref
        .read(soapLoadBuyQuotationsRepositoryProvider)
        .load(
          workingUrl: validatedUser!.enterprise!.workingUrl!,
          crossIdentity: validatedUser.user.CrossIdentity_Usuario!,
          enterpriseCode: enterpriseCode,
          codeForFullSearch: null,
        );
  }
}
