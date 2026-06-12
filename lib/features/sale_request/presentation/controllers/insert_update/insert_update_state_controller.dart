import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/resource/resource.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/insert_update/insert_update.dart';
import 'package:celta_inventario/features/sale_request/providers.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:collection/collection.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'insert_update_state_controller.g.dart';

@Riverpod(
  keepAlive: true,
  dependencies: [saleRequestArgs, SaleRequestDetailsStateController],
) //It is invalidating when close the page
class InsertUpdateStateController extends _$InsertUpdateStateController {
  BSFSaleRequestEntity? _lastProcessedSaleRequest;

  @override
  FutureOr<BSFSaleRequestEntity> build() async {
    ref.read(
      canAccessResourceStateControllerProvider(
        BsRoutine.saleRequest,
        BsResource.saleRequestChangeTPrice,
      ),
    );

    final args = ref.watch(saleRequestArgsProvider);

    final BSFSaleRequestEntity initialValue;
    if (args.saleRequestId == 0) {
      //!inserting
      initialValue = BSFSaleRequestEntity.empty();
    } else {
      initialValue = await ref.read(
        saleRequestDetailsStateControllerProvider(args).future,
      );
    }

    _lastProcessedSaleRequest = initialValue;
    return initialValue;
  }

  BSFSaleRequestEntity? get lastProcessedSaleRequest =>
      _lastProcessedSaleRequest;

  bool get needsProcessing {
    if (state is! AsyncData<BSFSaleRequestEntity>) return false;
    return state.value!.needsProcessingComparedTo(_lastProcessedSaleRequest);
  }

  (List<BSFProductItemEntity>, int) _getItemsAndIndexByPlu(String? plu) {
    final current = state.value!;
    final items = List<BSFProductItemEntity>.from(current.products ?? []);

    final index = items.indexWhere(
      (e) => e.product?.productPackingPriceLookUpString == plu,
    );

    return (items, index);
  }

  (String? errorMessage, List<BSFSaleRequestSanitizationAction> actions)
  addItem(ProductEntity product) {
    if (state is! AsyncData<BSFSaleRequestEntity>) {
      return (null, const []);
    }
    if (product.getPrice <= 0) {
      return ('Esse produto não possui preço'.hardcoded, const []);
    }

    final (items, index) = _getItemsAndIndexByPlu(product.PLU);
    final BSFProductItemEntity targetItem;

    if (index != -1) {
      targetItem = items[index].copyWith(
        quantity: (items[index].quantity ?? 0) + 1,
      );
    } else {
      targetItem = product.toBSFProductItemEntity().copyWith(quantity: 1);
    }

    if (targetItem.totalLiquid < 0) {
      return (
        'O valor líquido do produto não pode ser negativo.'.hardcoded,
        const [],
      );
    }

    if (index != -1) {
      items[index] = targetItem;
    } else {
      items.add(targetItem);
    }

    state = AsyncData(state.value!.copyWith(products: items));
    return (null, const []);
  }

  void removeItem(BSFProductItemEntity item) {
    if (state is! AsyncData<BSFSaleRequestEntity>) return;

    final (items, index) = _getItemsAndIndexByPlu(
      item.product?.productPackingPriceLookUpString,
    );

    if (index != -1) {
      items.removeAt(index);
      state = AsyncData(state.value!.copyWith(products: items));
    }
  }

  (String? errorMessage, List<BSFSaleRequestSanitizationAction> actions)
  increaseOrDecreaseUnit(
    BSFProductItemEntity item,
    bool isAdding, {
    bool onlyValidating = false,
  }) {
    if (state is! AsyncData<BSFSaleRequestEntity>) {
      return (null, const []);
    }

    final pc = item.priceCost;
    double price = item.value ?? 0;
    final minWhole = pc?.mininumQuantityForWholeSale ?? 0;
    final wholePrice =
        pc?.wholeSalePricePractice ?? pc?.salePracticedInWholeSale ?? 0;
    final retailPrice =
        pc?.saleRetailPricePractice ?? pc?.salePracticedInSaleRetail ?? 0;

    if ((item.value ?? 0) <= 0 && retailPrice == 0) {
      return ('Esse produto não possui preço'.hardcoded, const []);
    }

    final newQuantity = isAdding
        ? (item.quantity ?? 0) + 1
        : (item.quantity ?? 0) - 1;

    if (newQuantity <= 0) {
      if (!onlyValidating) {
        removeItem(item);
      }
      return (null, const []);
    }

    final (items, index) = _getItemsAndIndexByPlu(
      item.product?.productPackingPriceLookUpString,
    );

    if (index == -1) {
      final args = ref.read(saleRequestArgsProvider);
      final productEntity = item.toProductEntity(args.enterpriseCode);
      final tempItem = productEntity.toBSFProductItemEntity().copyWith(
        quantity: 1,
      );
      if (tempItem.totalLiquid <= 0) {
        return (
          'O valor líquido do produto deve ser maior que zero'.hardcoded,
          const [],
        );
      }
      if (!onlyValidating) {
        addItem(productEntity);
      }
      return (null, const []);
    } else {
      if (pc != null) {
        if (minWhole > 0 && newQuantity >= minWhole && wholePrice > 0) {
          price = wholePrice;
        } else if (retailPrice > 0) {
          price = retailPrice;
        }
      }

      final (
        sanitizedItem,
        actions,
      ) = BSFSaleRequestSanitizer.sanitizeProductQuantityChange(
        items[index],
        newQuantity,
        price,
      );

      if (sanitizedItem.totalLiquid <= 0) {
        return (
          'O valor líquido do produto deve ser maior que zero.'.hardcoded,
          const [],
        );
      }

      if (!onlyValidating) {
        items[index] = sanitizedItem;
        state = AsyncData(state.value!.copyWith(products: items));
      }
      return (null, actions);
    }
  }

  (String? errorMessage, List<BSFSaleRequestSanitizationAction> actions)
  updateItem(
    BSFProductItemEntity oldItem,
    BSFProductItemEntity newItem, {
    bool onlyValidating = false,
  }) {
    if (state is! AsyncData<BSFSaleRequestEntity>) {
      return (null, const []);
    }

    final hasAutomaticDiscount =
        newItem.discounts?.any(
          (e) => e.discountOrigin != DiscountOrigin.manual,
        ) ??
        false;
    final manualDiscounts =
        newItem.discounts
            ?.where((e) => e.discountOrigin == DiscountOrigin.manual)
            .toList() ??
        [];

    final actions = <BSFSaleRequestSanitizationAction>[];
    var sanitizedItem = newItem;

    final isQuantityChanged = oldItem.quantity != newItem.quantity;
    final isValueChanged = oldItem.value != newItem.value;
    if (hasAutomaticDiscount &&
        ((isQuantityChanged || isValueChanged) || manualDiscounts.isNotEmpty)) {
      actions.add(
        BSFSaleRequestSanitizationAction.productAutomaticDiscountsRemoved,
      );
      sanitizedItem = newItem.copyWith(discounts: manualDiscounts);
    }

    if (sanitizedItem.totalLiquid <= 0) {
      return (
        'O valor líquido do produto deve ser maior que zero'.hardcoded,
        const [],
      );
    }

    if (!onlyValidating) {
      final (items, index) = _getItemsAndIndexByPlu(
        oldItem.product?.productPackingPriceLookUpString,
      );

      if (index != -1) {
        items[index] = sanitizedItem;
      } else {
        items.add(sanitizedItem);
      }
      state = AsyncData(state.value!.copyWith(products: items));
    }

    return (null, actions);
  }

  List<BSFSaleRequestSanitizationAction> updateCustomerOrCovenant(
    BSFCustomerEntity customer, {
    BsfCovenantEntity? covenant,
    bool isChangingCovenant = false,
    bool onlyValidating = false,
  }) {
    if (state is! AsyncData<BSFSaleRequestEntity>) return const [];
    ref.read(selectedPaymentTypeStateControllerProvider.notifier).select(null);
    ref
        .read(selectedPaymentConditionStateControllerProvider.notifier)
        .select(null);

    final currentCustomer = state.value?.customer;
    BSFCustomerEntity? targetCustomer;
    BsfCovenantEntity? targetCovenant;

    if (isChangingCovenant) {
      if (customer.code != currentCustomer?.code) {
        targetCovenant = covenant;
      } else if (currentCustomer?.selectedCovenant?.code == covenant?.code) {
        targetCovenant = null;
      } else {
        targetCovenant = covenant;
      }
    }

    if (customer.code == currentCustomer?.code && !isChangingCovenant) {
      // Same customer re-clicked during validation: nothing to warn about.
      // Toggle: deselect the customer.
      targetCustomer = null;
    } else {
      targetCustomer = customer.copyWith(
        selectedCovenant: targetCovenant,
        annulSelectedCovenant: targetCovenant == null,
      );
    }

    final (
      sanitizedState,
      actions,
    ) = BSFSaleRequestSanitizer.sanitizeCustomerChange(
      state.value!,
      targetCustomer,
    );

    final isBlocked = actions.any(
      (a) => a.type == BSFSaleRequestSanitizationType.customerBlocked,
    );

    if (onlyValidating || isBlocked) {
      return actions;
    }

    state = AsyncData(sanitizedState);
    return const [];
  }

  void changeSeller(EcSellerEntity seller) {
    if (state is! AsyncData<BSFSaleRequestEntity>) return;

    final current = state.value!;

    state = AsyncData(current.copyWith(seller: seller.toBsfEmployee()));
  }

  void removeSeller() {
    if (state is! AsyncData<BSFSaleRequestEntity>) return;

    final current = state.value!;

    state = AsyncData(current.copyWith(annulSeller: true));
  }

  void updateCustomerData(BSFCustomerEntity customer) {
    if (state is! AsyncData<BSFSaleRequestEntity>) return;
    final current = state.value!;
    if (current.customer?.code != customer.code) return;

    final currentCovenantCode = current.customer?.selectedCovenant?.code;
    final updatedCovenant = customer.covenants?.firstWhereOrNull(
      (e) => e.code == currentCovenantCode,
    );

    final updatedCustomer = customer.copyWith(
      covenantCode: updatedCovenant?.code,
      selectedCovenant: updatedCovenant,
      annulCovenantCode: updatedCovenant == null,
      annulSelectedCovenant: updatedCovenant == null,
    );

    state = AsyncData(current.copyWith(customer: updatedCustomer));
  }

  (bool, String?) addPayment({
    required BSFPaymentFinalizationEntity payment,
    required double value,
    CreditCardPropertiesEntity? creditCardProperties,
  }) {
    if (state is! AsyncData<BSFSaleRequestEntity>) {
      return (false, 'Erro não esperado'.hardcoded);
    }

    final totalProducts = state.value!.totalProductsLiquid;
    final totalPayments = state.value!.totalPayments;

    // Convert to cents (integers) to prevent double-precision floating-point inaccuracies in money comparison
    final newPaymentCents = (value * 100).round();
    final totalProductsCents = (totalProducts * 100).round();
    final totalPaymentsCents = (totalPayments * 100).round();
    final toalMissingCents = totalProductsCents - totalPaymentsCents;

    if (newPaymentCents > toalMissingCents) {
      return (false, 'Valor excede o disponível'.hardcoded);
    }

    final current = state.value!;
    final isCovenant =
        payment.action?.type == PaymentFinalizationActionType.covenant;
    final selectedCovenant = state.value?.customer?.covenants?.firstWhereOrNull(
      (e) => e.code == state.value?.customer?.selectedCovenant?.code,
    );

    if (isCovenant && selectedCovenant == null) {
      return (false, 'Selecione um convênio'.hardcoded);
    }

    final financials = List<BSFFinancialEntity>.from(current.financials ?? []);

    if (financials.isEmpty) {
      financials.add(
        const BSFFinancialEntity(paymentFinalizations: [], paybackValue: 0),
      );
    }

    final lastFinancial = financials.last;
    final paymentFinalizations = List<BSFPaymentFinalizationWrapperEntity>.from(
      lastFinancial.paymentFinalizations ?? [],
    );

    paymentFinalizations.add(
      BSFPaymentFinalizationWrapperEntity(
        paymentFinalization: payment,
        value: value,
        quantityOfPortions: creditCardProperties?.quantityOfPortions,
        creditCardNumber: creditCardProperties?.creditCardNumber,
        creditCardValidate: creditCardProperties?.creditCardValidate,
        financialIncrement: 0,
        financialDiscount: 0,
        tefSequencialUniqueNumber: null,
        tefAutorizationCreditCode: null,
        devolutionCreditCode: null,
        identificationCode: isCovenant
            ? (selectedCovenant?.personalizedCode ??
                  selectedCovenant?.code?.toString())
            : null,
        paymentCondition: ref.read(
          selectedPaymentConditionStateControllerProvider,
        ),
        portions: null,
        userAuthorization: null,
      ),
    );

    financials[financials.length - 1] = lastFinancial.copyWith(
      paymentFinalizations: paymentFinalizations,
    );

    state = AsyncData(current.copyWith(financials: financials));

    ref.read(selectedPaymentTypeStateControllerProvider.notifier).select(null);
    ref
        .read(selectedPaymentConditionStateControllerProvider.notifier)
        .select(null);

    return (true, null);
  }

  void removePayment(int financialIndex, int paymentFinalizationIndex) {
    if (state is! AsyncData<BSFSaleRequestEntity>) return;
    final current = state.value!;
    final financials = List<BSFFinancialEntity>.from(current.financials ?? []);

    if (financials.isEmpty) return;

    if (financialIndex < 0 || financialIndex >= financials.length) return;
    final financial = financials[financialIndex];

    final paymentFinalizations = List<BSFPaymentFinalizationWrapperEntity>.from(
      financial.paymentFinalizations ?? [],
    );

    if (paymentFinalizations.length == 1) {
      financials.removeAt(financialIndex);
    } else {
      if (paymentFinalizationIndex < 0 ||
          paymentFinalizationIndex >= paymentFinalizations.length) {
        return;
      }
      paymentFinalizations.removeAt(paymentFinalizationIndex);
      financials[financialIndex] = financial.copyWith(
        paymentFinalizations: paymentFinalizations,
      );
    }

    state = AsyncData(current.copyWith(financials: financials));
  }

  String? updateFinancialIncrement(BSFValueTypeEntity value) {
    if (state.value?.requestType?.allowFinancialIncrement != true) {
      return 'O modelo de pedido não permite acréscimo financeiro'.hardcoded;
    } else if ((value.value ?? 0) <= 0) {
      return 'O valor deve ser maior que zero'.hardcoded;
    } else if (value.type == null) {
      return 'Selecione o tipo de acréscimo'.hardcoded;
    }

    state = AsyncData(state.value!.copyWith(financialIncrement: value));
    return null;
  }

  String? updateFinancialDiscount(BSFValueTypeEntity value) {
    if (state.value?.requestType?.allowFinancialDiscount != true) {
      return 'O modelo de pedido não permite desconto financeiro'.hardcoded;
    } else if ((value.value ?? 0) <= 0) {
      return 'O valor deve ser maior que zero'.hardcoded;
    } else if (value.type == null) {
      return 'Selecione o tipo de desconto'.hardcoded;
    }

    state = AsyncData(state.value!.copyWith(financialDiscount: value));
    return null;
  }

  void removeFinancialIncrement() {
    if (state is! AsyncData<BSFSaleRequestEntity>) return;
    state = AsyncData(state.value!.copyWith(annulFinancialIncrement: true));
  }

  void removeFinancialDiscount() {
    if (state is! AsyncData<BSFSaleRequestEntity>) return;
    state = AsyncData(state.value!.copyWith(annulFinancialDiscount: true));
  }

  void disposeFlow() {
    ref.invalidate(selectedPaymentConditionStateControllerProvider);
    ref.invalidate(selectedPaymentTypeStateControllerProvider);

    ref.invalidateSelf();
  }

  void updateProcessedCart(BSFSaleRequestEntity processedValue) {
    _lastProcessedSaleRequest = processedValue;
    state = AsyncData(processedValue);
  }

  void updateInstructions(String? value) {
    if (state is! AsyncData<BSFSaleRequestEntity>) return;

    state = AsyncData(state.value!.copyWith(instructions: value));
  }

  void updateObservations(String? value) {
    if (state is! AsyncData<BSFSaleRequestEntity>) return;

    state = AsyncData(state.value!.copyWith(observations: value));
  }
}

@Riverpod(
  dependencies: [
    saleRequestArgs,
    SaleRequestDetailsStateController,
    InsertUpdateStateController,
  ],
)
bool saleRequestHasChanges(Ref ref) {
  final args = ref.watch(saleRequestArgsProvider);
  final current = ref.watch(insertUpdateStateControllerProvider).value;

  if (current == null) return false;

  if (args.saleRequestId == 0) {
    // For new requests: disable when there's no meaningful data yet
    final hasCustomer = current.customer?.code != null;
    final hasProducts = current.products?.isNotEmpty == true;
    return hasCustomer || hasProducts;
  }

  // For existing requests: compare with the original
  final original = ref
      .watch(saleRequestDetailsStateControllerProvider(args))
      .value;

  if (original == null) return false;

  return current != original;
}

@Riverpod(dependencies: [InsertUpdateStateController])
bool saleRequestNeedsProcessing(Ref ref) {
  ref.watch(insertUpdateStateControllerProvider);
  return ref.read(insertUpdateStateControllerProvider.notifier).needsProcessing;
}
