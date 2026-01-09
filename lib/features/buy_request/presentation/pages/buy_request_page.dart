import 'package:celta_intelligence/commom_widgets/commom_widgets.dart';
import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:celta_intelligence/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../constants/constants.dart';
import '../../../../core/domain/entities/entities.dart';
import '../../../../core/presentation/controllers/supplier/supplier.dart';
import '../../domain/entities/entities.dart';
import '../controllers/controllers.dart';
import 'components/components.dart';
import 'pages.dart';

class BuyRequestPage extends ConsumerStatefulWidget {
  const BuyRequestPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BuyRequestPageState();
}

class _BuyRequestPageState extends ConsumerState<BuyRequestPage> {
  final supplierController = TextEditingController();
  final identificationFormKey = GlobalKey<FormState>();
  final productsFieldsFormKey = GlobalKey<FormState>();
  final productsQuantityFormKey = GlobalKey<FormState>();
  final searchProductController = TextEditingController();
  final quantityController = TextEditingController();
  final observationsController = TextEditingController();
  final costController = TextEditingController();
  final quantityFocusNode = FocusNode();
  final costFocusNode = FocusNode();

  List<SupplierEntity> suppliers = [];
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        suppliers = await ref
            .read(
              supplierStateControllerProvider(
                SearchSupplierType.buyRequest,
              ).future,
            )
            .then((value) {
              return [...?value];
            });

        final pendingAsync = await ref.read(
          pendingBuyRequestStateControllerProvider.future,
        );

        if (pendingAsync.selectedSupplier != null &&
            suppliers.any(
                  (e) => e.Code == pendingAsync.selectedSupplier?.Code,
                ) !=
                true) {
          setState(() {
            suppliers.add(pendingAsync.selectedSupplier!);
          });
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    supplierController.dispose();
    searchProductController.dispose();
    quantityController.dispose();
    observationsController.dispose();
    costController.dispose();
    quantityFocusNode.dispose();
    costFocusNode.dispose();
  }

  void insertProduct(
    AsyncValue<PendingBuyRequestEntity> pendingAsync,
    ProductEntity product,
  ) {
    if (productsQuantityFormKey.currentState?.validate() != true) {
      quantityFocusNode.requestFocus();
      return;
    }

    if (productsFieldsFormKey.currentState?.validate() != true) {
      costFocusNode.requestFocus();
      return;
    }
    final products = pendingAsync.value?.products ?? {};
    products.addAll({
      ProductKey(
        enterpriseCode: product.EnterpriseCode!,
        productPackingCode: product.ProductPackingCode!,
      ): BuyRequestProductItemEntity(
        product: product,
        quantity: quantityController.text.toDouble()!,
        cost: costController.text.toDouble()!,
      ),
    });
    ref
        .read(pendingBuyRequestStateControllerProvider.notifier)
        .updatePending(pendingAsync.value!.copyWith(products: products));
    quantityController.clear();
    costController.clear();
    ref
        .read(uiStateControllerProvider.notifier)
        .updateSelectedProductIndex(null);
  }

  void onTapProduct(int index, ProductEntity product) async {
    quantityController.clear();
    costController.clear();

    ref
        .read(uiStateControllerProvider.notifier)
        .updateSelectedProductIndex(index);

    if ((product.PriceCost!.LiquidCost ?? 0) > 0) {
      costController.text = product.PriceCost!.LiquidCost
          .toString()
          .toBrazilianNumber(4);
    }

    Future.delayed(const Duration(milliseconds: 100), () {
      quantityFocusNode.requestFocus();
    });
  }

  final appBarTitles = [
    'Identificação'.hardcoded,
    'Empresas'.hardcoded,
    'Produtos'.hardcoded,
    'Confirmação'.hardcoded,
  ];

  @override
  Widget build(BuildContext context) {
    final pendingAsync = ref.watch(pendingBuyRequestStateControllerProvider);

    final productsPage = ProductsPage(
      searchProductController: searchProductController,
      quantityController: quantityController,
      costController: costController,
      quantityFocusNode: quantityFocusNode,
      costFocusNode: costFocusNode,
      insertProduct: insertProduct,
      fieldsFormKey: productsFieldsFormKey,
      quantityFormKey: productsQuantityFormKey,
      onTapProduct: onTapProduct,
    );

    final pages = [
      IdentificationPage(
        supplierController: supplierController,
        identificationFormKey: identificationFormKey,
        suppliers: suppliers,
      ),
      const EnterprisesPage(),
      productsPage,
      ConfirmationPage(
        productsPage: productsPage,
        observationsController: observationsController,
      ),
    ];

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: FittedBox(
              child: Text(
                appBarTitles[ref.watch(
                  uiStateControllerProvider.select(
                    (s) => s.value?.currentPageIndex ?? 0,
                  ),
                )],
              ),
            ),
            actionsPadding: const EdgeInsets.fromLTRB(
              0,
              Sizes.p8,
              Sizes.p12,
              Sizes.p8,
            ),
            actions: [
              CartPriceIcon(
                onTap: () {
                  ref
                      .read(uiStateControllerProvider.notifier)
                      .updatePageIndex(3);
                },
                pendingAsync: pendingAsync,
              ),
            ],
          ),
          body: IndexedStack(
            index: ref.watch(
              uiStateControllerProvider.select(
                (s) => s.value?.currentPageIndex ?? 0,
              ),
            ),
            children: pages,
          ),
          bottomNavigationBar: BottomNavBar(
            currentIndex: ref.watch(
              uiStateControllerProvider.select(
                (s) => s.value?.currentPageIndex ?? 0,
              ),
            ),
            onTap: (index) {
              bool enterprisesAreValid =
                  pendingAsync.value?.selectedEnterprises != null &&
                  pendingAsync.value!.selectedEnterprises!.isNotEmpty;
              bool buyerIsSelected = pendingAsync.value?.selectedBuyer != null;
              bool requestTypeIsSelected =
                  pendingAsync.value?.selectedRequestType != null;
              bool supplierIsSelected =
                  pendingAsync.value?.selectedSupplier != null;

              final currentIndex = ref.watch(
                uiStateControllerProvider.select(
                  (s) => s.value?.currentPageIndex ?? 0,
                ),
              );

              if (currentIndex == 0 && (index == 1 || index == 2)) {
                bool isValid =
                    identificationFormKey.currentState?.validate() == true;
                if (!isValid) {
                  return;
                } else if (pendingAsync.value?.selectedSupplier == null) {
                  showSnackBarMessage(
                    context,
                    'Selecione um fornecedor'.hardcoded,
                    backgroundColor: Colors.red,
                  );
                  return;
                }
              }

              if ((index == 1 || index == 2)) {
                if (!buyerIsSelected ||
                    !requestTypeIsSelected ||
                    !supplierIsSelected) {
                  showSnackBarMessage(
                    context,
                    'Preencha os campos de identificação'.hardcoded,
                    backgroundColor: Colors.red,
                  );
                  return;
                }
              }

              if (index == 2 && !enterprisesAreValid) {
                showSnackBarMessage(
                  context,
                  'Selecione pelo menos uma empresa'.hardcoded,
                  backgroundColor: Colors.red,
                );
                return;
              }

              ref
                  .read(uiStateControllerProvider.notifier)
                  .updatePageIndex(index);
            },
          ),
        ),
        LoadingPage(providers: [insertBuyRequestControllerProvider]),
      ],
    );
  }
}
