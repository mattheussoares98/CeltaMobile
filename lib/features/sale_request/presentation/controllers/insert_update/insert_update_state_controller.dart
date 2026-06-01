import 'package:celta_inventario/core/domain/entities/entities.dart';
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
    return state.value! != _lastProcessedSaleRequest;
  }

  (List<BSFProductItemEntity>, int) _getItemsAndIndexByPlu(String? plu) {
    final current = state.value!;
    final items = List<BSFProductItemEntity>.from(current.products ?? []);

    final index = items.indexWhere(
      (e) => e.product?.productPackingPriceLookUpString == plu,
    );

    return (items, index);
  }

  void addItem(ProductEntity product) {
    if (state is! AsyncData<BSFSaleRequestEntity>) return;
    if (product.getPrice <= 0) return;

    final (items, index) = _getItemsAndIndexByPlu(product.PLU);

    if (index != -1) {
      items[index] = items[index].copyWith(
        quantity: (items[index].quantity ?? 0) + 1,
      );
    } else {
      items.add(product.toBSFProductItemEntity().copyWith(quantity: 1));
    }

    state = AsyncData(state.value!.copyWith(products: items));
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

  void increaseOrDecreaseUnit(BSFProductItemEntity item, bool isAdding) {
    if (state is! AsyncData<BSFSaleRequestEntity>) return;

    final newQuantity = isAdding
        ? (item.quantity ?? 0) + 1
        : (item.quantity ?? 0) - 1;

    if (newQuantity <= 0) {
      removeItem(item);
      return;
    }

    final (items, index) = _getItemsAndIndexByPlu(
      item.product?.productPackingPriceLookUpString,
    );

    if (index == -1) {
      final args = ref.read(saleRequestArgsProvider);
      addItem(item.toProductEntity(args.enterpriseCode));
      return;
    } else {
      final pc = item.priceCost;
      double price = item.value ?? 0;

      if (pc != null) {
        final minWhole = pc.mininumQuantityForWholeSale ?? 0;
        final wholePrice =
            pc.salePracticedInWholeSale ?? pc.wholeSalePricePractice ?? 0;
        final retailPrice =
            pc.salePracticedInSaleRetail ?? pc.saleRetailPricePractice ?? 0;

        if (minWhole > 0 && newQuantity >= minWhole && wholePrice > 0) {
          price = wholePrice;
        } else if (retailPrice > 0) {
          price = retailPrice;
        }
      }

      items[index] = items[index].copyWith(quantity: newQuantity, value: price);
      state = AsyncData(state.value!.copyWith(products: items));
    }
  }

  void updateItem(BSFProductItemEntity oldItem, BSFProductItemEntity newItem) {
    if (state is! AsyncData<BSFSaleRequestEntity>) return;
    final (items, index) = _getItemsAndIndexByPlu(
      oldItem.product?.productPackingPriceLookUpString,
    );

    if (index != -1) {
      items[index] = newItem;
    } else {
      items.add(newItem);
    }
    state = AsyncData(state.value!.copyWith(products: items));
  }

  List<BSFSaleRequestSanitizationAction> updateCustomerOrCovenant(
    BSFCustomerEntity? customer, {
    BsfCovenantEntity? covenant,
    bool isChangingCovenant = false,
    bool onlyValidating = false,
  }) {
    if (state is! AsyncData<BSFSaleRequestEntity>) return const [];
    ref.read(selectedPaymentTypeStateControllerProvider.notifier).select(null);
    ref
        .read(selectedPaymentConditionStateControllerProvider.notifier)
        .select(null);

    BSFCustomerEntity? targetCustomer;
    BsfCovenantEntity? targetCovenant;

    final currentCustomer = state.value?.customer;

    if (isChangingCovenant) {
      if (customer?.selectedCovenant?.code == covenant?.code &&
          customer?.code == currentCustomer?.code) {
        targetCovenant = null;
      } else {
        targetCovenant = covenant;
      }
    }

    if (customer == null) {
      targetCustomer = null;
    } else {
      if (customer.code == currentCustomer?.code && !isChangingCovenant) {
        // Same customer re-clicked during validation: nothing to warn about.
        // Toggle: deselect the customer.
        targetCustomer = null;
      } else {
        targetCustomer = customer.copyWith(
          selectedCovenant: targetCovenant,
          annulSelectedCovenant: isChangingCovenant && targetCovenant == null,
        );
      }
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

    final currentCovenantCode = current.customer?.covenantCode;
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

  List<BSFSaleRequestSanitizationAction> updateRequestType(
    BSFRequestTypeEntity requestType, {
    bool onlyValidating = false,
  }) {
    if (state is! AsyncData<BSFSaleRequestEntity>) return const [];
    final current = state.value!;

    final (sanitizedState, actions) =
        BSFSaleRequestSanitizer.sanitizeRequestTypeChange(current, requestType);

    if (actions.isNotEmpty && onlyValidating) {
      return actions;
    } else if (onlyValidating) {
      return [];
    }

    state = AsyncData(sanitizedState);
    return const [];
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

    if (value > totalProducts - totalPayments) {
      //TODO FIX FLOAT ERROR
      return (false, 'Valor excede o disponível'.hardcoded);
    }

    final current = state.value!;
    final isCovenant =
        payment.action?.type == PaymentFinalizationActionType.covenant;
    final selectedCovenant = state.value?.customer?.covenants?.firstWhereOrNull(
      (e) => e.code == state.value?.customer?.covenantCode,
    );

    if (isCovenant && selectedCovenant == null) {
      //TODO create tests
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
        //TODO confirm if this is the correct way to save the covenant payment method
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

  void removePayment(int index) {
    if (state is! AsyncData<BSFSaleRequestEntity>) return;
    final current = state.value!;
    final financials = List<BSFFinancialEntity>.from(current.financials ?? []);

    if (financials.isEmpty) return;

    final paymentFinalizations = List<BSFPaymentFinalizationWrapperEntity>.from(
      financials.first.paymentFinalizations ?? [],
    );
    paymentFinalizations.removeAt(index);

    financials.first = financials.first.copyWith(
      paymentFinalizations: paymentFinalizations,
    );

    state = AsyncData(current.copyWith(financials: financials));
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
  if (args.saleRequestId == 0) return false;

  final original = ref
      .watch(saleRequestDetailsStateControllerProvider(args))
      .value;
  final current = ref.watch(insertUpdateStateControllerProvider).value;

  // While either provider is still loading, there are no "changes" yet.
  if (original == null || current == null) return false;

  return current != original;
}
