import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/domain/entities/entities.dart';
import '../../domain/entities/bsf/bsf.dart';
import '../../domain/entities/entities.dart';
import 'controllers.dart';

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

    final paymentOptionsFuture = ref.read(
      paymentOptionsStateControllerProvider(enterpriseCode).future,
    );

    if (saleRequestId == 0) {
      //!inserting
      await paymentOptionsFuture;
      return BSFSaleRequestEntity.empty();
    }

    final saleRequestDetailsFuture = ref.read(
      saleRequestDetailsStateControllerProvider(
        customerCode: customerCode,
        enterpriseCode: enterpriseCode,
        saleRequestCode: saleRequestId,
      ).future,
    );

    final results = await Future.wait([
      paymentOptionsFuture,
      saleRequestDetailsFuture,
    ]);

    return results[1] as BSFSaleRequestEntity;
  }

  void addItem(ProductEntity product) {
    if (state is! AsyncData<BSFSaleRequestEntity>) return;
    if (product.getPrice <= 0) return;

    final current = state.value!;
    final items = List<BSFProductItemEntity>.from(current.products ?? []);

    final productCode =
        product.ProductPackingCode?.toString() ??
        product.ProductCode?.toString();
    final index = items.indexWhere(
      (e) => e.product?.personalizedCode == productCode,
    );

    if (index != -1) {
      items[index] = items[index].copyWith(
        quantity: (items[index].quantity ?? 0) + 1,
      );
    } else {
      items.add(product.toBSFProductItemEntity());
    }

    state = AsyncData(current.copyWith(products: items));
  }

  void removeItem(BSFProductItemEntity item) {
    if (state is! AsyncData<BSFSaleRequestEntity>) return;
    final current = state.value!;
    final items = List<BSFProductItemEntity>.from(current.products ?? []);

    final index = items.indexWhere(
      (e) => e.productPackingCode == item.productPackingCode,
    );

    if (index != -1) {
      items.removeAt(index);
      state = AsyncData(current.copyWith(products: items));
    }
  }

  void updateItemQuantity(BSFProductItemEntity item, double quantity) {
    if (state is! AsyncData<BSFSaleRequestEntity>) return;

    if (quantity <= 0) {
      removeItem(item);
      return;
    }

    final current = state.value!;
    final items = List<BSFProductItemEntity>.from(current.products ?? []);
    final index = items.indexWhere(
      (e) => e.productPackingCode == item.productPackingCode,
    );
    if (index != -1) {
      final pc = items[index].priceCost;
      double price = items[index].value ?? 0;

      if (pc != null) {
        final minWhole = pc.mininumQuantityForWholeSale ?? 0;
        final wholePrice =
            pc.salePracticedInWholeSale ?? pc.wholeSalePricePractice ?? 0;
        final retailPrice =
            pc.salePracticedInSaleRetail ?? pc.saleRetailPricePractice ?? 0;

        if (minWhole > 0 && quantity >= minWhole && wholePrice > 0) {
          price = wholePrice;
        } else if (retailPrice > 0) {
          price = retailPrice;
        }
      }

      items[index] = items[index].copyWith(quantity: quantity, value: price);
      state = AsyncData(current.copyWith(products: items));
    }
  }

  void updateItem(BSFProductItemEntity oldItem, BSFProductItemEntity newItem) {
    if (state is! AsyncData<BSFSaleRequestEntity>) return;
    final current = state.value!;
    final items = List<BSFProductItemEntity>.from(current.products ?? []);
    final index = items.indexWhere(
      (e) => e.productPackingCode == oldItem.productPackingCode,
    );
    if (index != -1) {
      items[index] = newItem;
    } else {
      items.add(newItem);
    }
    state = AsyncData(current.copyWith(products: items));
  }

  void updateCustomer(CustomerEntity customer) {
    if (state is! AsyncData<BSFSaleRequestEntity>) return;
    final current = state.value!;
    state = AsyncData(
      current.copyWith(customer: customer.toBSFCustomerEntity()),
    );
  }

  void updateRequestType(BSFRequestTypeEntity requestType) {
    if (state is! AsyncData<BSFSaleRequestEntity>) return;
    final current = state.value!;
    state = AsyncData(current.copyWith(requestType: requestType));
  }

  void addPayment(BSFPaymentFinalizationEntity payment, double value) {
    if (state is! AsyncData<BSFSaleRequestEntity>) return;

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
        financialIncrement: 0,
        financialDiscount: 0,
        quantityOfPortions: 1,
        tefSequencialUniqueNumber: null,
        tefAutorizationCreditCode: null,
        devolutionCreditCode: null,
        identificationCode: null,
        paymentCondition: null,
        creditCardNumber: null,
        creditCardValidate: null,
        portions: null,
        userAuthorization: null,
      ),
    );

    financials[financials.length - 1] = lastFinancial.copyWith(
      paymentFinalizations: paymentFinalizations,
    );

    state = AsyncData(current.copyWith(financials: financials));
  }

  void removePayment(BSFPaymentFinalizationWrapperEntity payment) {
    if (state is! AsyncData<BSFSaleRequestEntity>) return;
    final current = state.value!;
    final financials = List<BSFFinancialEntity>.from(current.financials ?? []);

    if (financials.isEmpty) return;

    for (var i = 0; i < financials.length; i++) {
      final paymentFinalizations =
          List<BSFPaymentFinalizationWrapperEntity>.from(
            financials[i].paymentFinalizations ?? [],
          );
      if (paymentFinalizations.contains(payment)) {
        paymentFinalizations.remove(payment);
        financials[i] = financials[i].copyWith(
          paymentFinalizations: paymentFinalizations,
        );
        break;
      }
    }

    state = AsyncData(current.copyWith(financials: financials));
  }
}
