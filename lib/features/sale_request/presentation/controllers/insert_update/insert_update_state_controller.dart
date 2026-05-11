import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../core/domain/entities/entities.dart';
import '../../../domain/entities/bsf/bsf.dart';
import '../../../domain/entities/entities.dart';
import 'insert_update.dart';

part 'insert_update_state_controller.g.dart';

@riverpod
class InsertUpdateStateController extends _$InsertUpdateStateController {
  @override
  FutureOr<BSFSaleRequestEntity> build({
    required int enterpriseCode,
    required int customerCode,
    required int saleRequestId,
  }) async {
    Timer? timer;
    final link = ref.keepAlive();
    ref.onCancel(() {
      timer = Timer(
        Duration(seconds: saleRequestId == 0 ? 9999 : 0),
        () => link.close(),
      );
    });
    ref.onResume(() {
      timer?.cancel();
    });
    ref.onDispose(() {
      timer?.cancel();
    });

    if (saleRequestId == 0) {
      //!inserting
      return BSFSaleRequestEntity.empty();
    }

    return await ref.read(
      saleRequestDetailsStateControllerProvider(
        customerCode: customerCode,
        enterpriseCode: enterpriseCode,
        saleRequestCode: saleRequestId,
      ).future,
    );
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
      addItem(item.toProductEntity(enterpriseCode));
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

  void updateCustomer(CustomerEntity customer) {
    if (state is! AsyncData<BSFSaleRequestEntity>) return;
    state = AsyncData(
      state.value!.copyWith(customer: customer.toBSFCustomerEntity()),
    );
  }

  void updateRequestType(BSFRequestTypeEntity requestType) {
    if (state is! AsyncData<BSFSaleRequestEntity>) return;
    state = AsyncData(state.value!.copyWith(requestType: requestType));
  }

  void addPayment({
    required BSFPaymentFinalizationEntity payment,
    required double value,
    CreditCardPropertiesEntity? creditCardProperties,
  }) {
    if (state is! AsyncData<BSFSaleRequestEntity>) return;

    ref
        .read(
          selectedPaymentTypeStateControllerProvider(saleRequestId).notifier,
        )
        .select(null);
    ref
        .read(selectedPaymentConditionStateControllerProvider.notifier)
        .select(null);

    final current = state.value!;
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
        identificationCode: null,
        paymentCondition: null,
        portions: null,
        userAuthorization: null,
      ),
    );

    financials[financials.length - 1] = lastFinancial.copyWith(
      paymentFinalizations: paymentFinalizations,
    );

    state = AsyncData(current.copyWith(financials: financials));
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
}
