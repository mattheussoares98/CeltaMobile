import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/domain/entities/entities.dart';
import '../../../../core/presentation/controllers/user_session/user_session.dart';
import '../../domain/entities/entities.dart';
import '../../providers.dart';

part 'complete_buy_quotation_state_controller.g.dart';

@riverpod
class CompleteBuyQuotationsStateController
    extends _$CompleteBuyQuotationsStateController {
  @override
  FutureOr<BuyQuotationEntity> build(
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

  bool updateValues({
    DateTime? DateOfLimit,
    bool? annulDateOfLimit,
    String? Observations,
    BuyerEntity? Buyer,
    List<BuyQuotationEnterpriseEntity>? Enterprises,
    List<BuyQuotationProductsEntity>? Products,
  }) {
    // 1. Ensure the current state is data (not loading or error)
    final currentState = state.value;
    if (currentState == null) return false;

    if (!_enterprisesAreValid(Enterprises)) {
      return false;
    }
    if (!_productsAreValid(Products)) {
      return false;
    }

    // 2. Perform the immutable update using copyWith
    final updatedEntity = BuyQuotationEntity.empty().copyWith(
      Code: state.value!.Code,
      PersonalizedCode: state.value!.PersonalizedCode,
      DateOfCreation: state.value!.DateOfCreation,
      DateOfLimit: annulDateOfLimit == true
          ? null
          : DateOfLimit ?? state.value!.DateOfLimit,
      Observations: Observations ?? state.value!.Observations,
      Buyer: Buyer ?? state.value!.Buyer,
      Enterprises: Enterprises ?? state.value!.Enterprises,
      Products: Products ?? state.value!.Products,
    );
    state = AsyncValue.data(updatedEntity);
    return true;
  }

  bool _enterprisesAreValid(List<BuyQuotationEnterpriseEntity>? enterprises) {
    if (enterprises == null) return true;
    // 1. Get all codes
    final codes = enterprises.map((e) => e.Code).toList();
    return codes.length == codes.toSet().length;
  }

  // Helper to check for duplicate product packing codes
  bool _productsAreValid(List<BuyQuotationProductsEntity>? products) {
    if (products == null) return true;

    // 1. Get all product packing codes
    final codes = products.map((e) => e.Product?.ProductPackingCode).toList();

    return codes.length == codes.toSet().length;
  }
}
