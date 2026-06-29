import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/presentation/controllers/enterprises/enterprises.dart';
import 'package:celta_inventario/features/buy_quotation/presentation/controllers/controller.dart';
import 'package:celta_inventario/features/buy_quotation/presentation/models/models.dart';
import 'package:celta_inventario/features/buy_quotation/presentation/pages/insert_update/components/components.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class InsertUpdatePage extends ConsumerStatefulWidget {
  final int code;
  final int enterpriseCode;
  const InsertUpdatePage({
    super.key,
    required this.code,
    required this.enterpriseCode,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _InsertUpdatePageState();
}

class _InsertUpdatePageState extends ConsumerState<InsertUpdatePage> {
  final observationController = TextEditingController();
  final searchValueController = TextEditingController();
  final filterProductsController = TextEditingController();
  final filterProductsFocusNode = FocusNode();
  final observationsFocusNode = FocusNode();
  final List<EnterpriseUIController> uiControllers = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        //almost instantly because the data was already loaded
        final enterprises = await ref.read(
          enterprisesStateControllerProvider().future,
        );

        for (final enterprise in enterprises) {
          uiControllers.add(
            EnterpriseUIController(
              TextEditingController(),
              FocusNode(),
              enterprise.Code!,
              enterprise.PersonalizedCode!,
            ),
          );
        }

        final value = await ref.read(
          completeBuyQuotationsStateControllerProvider(
            widget.enterpriseCode,
            widget.code.toString(),
          ).future,
        );
        if (value.Observations != null && value.Observations!.isNotEmpty) {
          observationController.text = value.Observations!;
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    observationController.dispose();
    searchValueController.dispose();
    filterProductsController.dispose();
    filterProductsFocusNode.dispose();
    observationsFocusNode.dispose();

    for (final uiController in uiControllers) {
      uiController.controller.dispose();
      uiController.focusNode.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(
      saveBuyQuotationControllerProvider(
        widget.enterpriseCode,
        widget.code.toString(),
      ),
      (p, n) {
        n.showAlertDialogOnError(context);
      },
    );

    ref.observeLoading([
      saveBuyQuotationControllerProvider(
        widget.enterpriseCode,
        widget.code.toString(),
      ),
    ]);

    return BaseScaffold(
      isScrollable: false,
      usePadding: true,
      resizeToAvoidBottomInset: true,
      onPopInvokedWithResult: () async {
        bool? confirmed = await showAlertDialog(
          context: context,
          title: 'Atenção'.hardcoded,
          cancelActionText: 'Cancelar'.hardcoded,
          defaultActionText: 'Sair sem salvar'.hardcoded,
          content:
              'Caso tenha feito alguma alteração, ao sair da página sem salvar, essa alteração será perdida. Deseja sair mesmo assim?'
                  .hardcoded,
        );

        if (confirmed == true && context.mounted) {
          context.pop();
        }
      },
      appBar: BaseAppBar(
        title: widget.code == 0 ? 'Inserindo'.hardcoded : 'Alterando'.hardcoded,
        actions: [
          SaveIconButton(
            enterpriseCode: widget.enterpriseCode,
            code: widget.code,
            observationController: observationController,
            observationsFocusNode: observationsFocusNode,
          ),
        ],
      ),
      body: OptimazedAsyncValueWidget(
        provider: completeBuyQuotationsStateControllerProvider(
          widget.enterpriseCode,
          widget.code.toString(),
        ),
        tryAgain: () => ref.invalidate(
          completeBuyQuotationsStateControllerProvider(
            widget.enterpriseCode,
            widget.code.toString(),
          ),
        ),
        child: CustomScrollView(
          physics: const ClampingScrollPhysics(),
          slivers: [
            Code(code: widget.code),
            CreationDate(
              enterpriseCode: widget.enterpriseCode,
              code: widget.code,
            ),
            LimitDate(code: widget.code, enterpriseCode: widget.enterpriseCode),
            gapSliverH8,
            BuyersDropdown(
              enterpriseCode: widget.enterpriseCode,
              code: widget.code,
            ),
            gapSliverH8,
            ObservationField(
              observationController: observationController,
              observationsFocusNode: observationsFocusNode,
            ),
            const SliverToBoxAdapter(child: Divider()),
            Enterprises(
              enterpriseCode: widget.enterpriseCode,
              code: widget.code,
            ),
            const SliverToBoxAdapter(child: Divider()),
            FilterProducts(
              enterpriseCode: widget.enterpriseCode,
              code: widget.code,
              filterProductsFocusNode: filterProductsFocusNode,
              filterProductsController: filterProductsController,
            ),
            SearchProductField(
              enterpriseCode: widget.enterpriseCode,
              code: widget.code,
              searchValueController: searchValueController,
            ),
            gapSliverH8,
            ProductsItems(
              uiControllers: uiControllers,
              widget: widget,
              observationsFocusNode: observationsFocusNode,
              filterProductsController: filterProductsController,
            ),
            gapSliverH32,
          ],
        ),
      ),
    );
  }
}
