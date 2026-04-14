import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/domain/entities/entities.dart';
import '../../../../core/presentation/controllers/user_session/user_session.dart';
import '../../domain/entities/bsf/bsf.dart';
import '../../domain/entities/entities.dart';
import '../../providers.dart';
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
      timer = Timer(const Duration(seconds: 20), () {
        link.close();
      });
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
    items.remove(item);
    state = AsyncData(current.copyWith(products: items));
  }

  void updateItemQuantity(BSFProductItemEntity item, double quantity) {
    if (state is! AsyncData<BSFSaleRequestEntity>) return;
    final current = state.value!;
    final items = List<BSFProductItemEntity>.from(current.products ?? []);
    final index = items.indexOf(item);
    if (index != -1) {
      items[index] = items[index].copyWith(quantity: quantity);
      state = AsyncData(current.copyWith(products: items));
    }
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

  Future<bool> save() async {
    if (state is! AsyncData<BSFSaleRequestEntity>) return false;

    final saleRequest = state.value!;
    final userSession = await ref.read(validatedUserSessionProvider.future);

    final params = EcRequestParams(
      workingUrl: userSession!.enterprise!.workingUrl!,
      user: userSession.user.name!,
      accessKey: userSession.user.AccessKey!,
    );

    final result = await ref
        .read(ecSaleRequestsRepositoryProvider)
        .update(
          saleRequest: saleRequest,
          enterpriseCode: enterpriseCode,
          params: params,
        );

    return result;
  }
}
