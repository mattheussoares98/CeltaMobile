import 'package:celta_intelligence/commom_widgets/commom_widgets.dart';
import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:celta_intelligence/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../constants/constants.dart';
import '../../../../core/domain/entities/entities.dart';
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
  int currentIndex = 0;
  int? selectedProductIndex;
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

    identificationFormKey.currentState?.dispose();
    productsFieldsFormKey.currentState?.dispose();
    productsQuantityFormKey.currentState?.dispose();
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
        enterpriseCode: product.EnterpriseCode,
        productPackingCode: product.ProductPackingCode,
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
    setState(() {
      selectedProductIndex = null;
    });
  }

  void onTapProduct(int index, ProductEntity product) {
    quantityController.clear();
    costController.clear();

    if (selectedProductIndex != index) {
      if ((product.PriceCost.LiquidCost ?? 0) > 0) {
        costController.text = product.PriceCost.LiquidCost
            .toString()
            .toBrazilianNumber(4);
      }
      setState(() {
        selectedProductIndex = index;
      });
      Future.delayed(Duration(milliseconds: 100), () {
        quantityFocusNode.requestFocus();
      });
    } else {
      setState(() {
        selectedProductIndex = null;
      });
    }
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
      selectedIndex: selectedProductIndex,
      onTapProduct: onTapProduct,
      changeSelectedIndex: (index) {
        setState(() {
          selectedProductIndex = index;
        });
      },
    );

    final pages = [
      IdentificationPage(
        supplierController: supplierController,
        identificationFormKey: identificationFormKey,
        suppliers: suppliers,
      ),
      EnterprisesPage(),
      productsPage,
      ConfirmationPage(
        productsPage: productsPage,
        observationsController: observationsController,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: FittedBox(child: Text(appBarTitles[currentIndex])),
        actionsPadding: const EdgeInsets.all(Sizes.p8),
        actions: [
          CartPriceIcon(
            onTap: () {
              setState(() {
                currentIndex = 3;
              });
            },
            pendingAsync: pendingAsync,
          ),
        ],
      ),
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavBar(
        currentIndex: currentIndex,
        onTap: (index) {
          bool enterprisesAreValid =
              pendingAsync.value?.selectedEnterprises != null &&
              pendingAsync.value!.selectedEnterprises!.isNotEmpty;
          bool buyerIsSelected = pendingAsync.value?.selectedBuyer != null;
          bool requestTypeIsSelected =
              pendingAsync.value?.selectedRequestType != null;
          bool supplierIsSelected =
              pendingAsync.value?.selectedSupplier != null;

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

          setState(() => currentIndex = index);
        },
      ),
    );
  }
}
