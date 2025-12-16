import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../../../../utils/utils.dart';
import '../../../../enterprises/presentation/controllers/controllers.dart';
import '../../controllers/controller.dart';
import 'components/components.dart';

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
  final Map<String, TextEditingController> quantityControllers = {};

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
          quantityControllers[enterprise.Code.toString()] =
              TextEditingController();
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

    for (final controller in quantityControllers.values) {
      controller.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;

    ref.listen(
      saveBuyQuotationControllerProvider(
        widget.enterpriseCode,
        widget.code.toString(),
      ),
      (p, n) {
        n.showAlertDialogOnError(context);
      },
    );

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text(
              widget.code == 0 ? 'Inserindo'.hardcoded : 'Alterando'.hardcoded,
            ),
            actions: [
              IconButton(
                onPressed: () {
                  showAlertDialog(
                    context: context,
                    title: 'Salvar'.hardcoded,
                    content: 'Deseja salvar as alterações?'.hardcoded,
                    cancelActionText: 'Cancelar'.hardcoded,
                    defaultActionText: 'Salvar'.hardcoded,
                    onOkPressed: () {
                      ref
                          .read(
                            saveBuyQuotationControllerProvider(
                              widget.enterpriseCode,
                              widget.code.toString(),
                            ).notifier,
                          )
                          .save();
                    },
                  );
                },
                icon: Icon(isIOS ? CupertinoIcons.check_mark : Icons.save),
              ),
            ],
          ),
          body: AsyncValueWidget(
            value: ref.watch(
              completeBuyQuotationsStateControllerProvider(
                widget.enterpriseCode,
                widget.code.toString(),
              ),
            ),
            tryAgain: () => ref.invalidate(
              completeBuyQuotationsStateControllerProvider(
                widget.enterpriseCode,
                widget.code.toString(),
              ),
            ),
            data: (buyQuotation) {
              return Padding(
                padding: const EdgeInsets.all(Sizes.p8),
                child: CustomScrollView(
                  slivers: [
                    Code(buyQuotation: buyQuotation),
                    CreationDate(buyQuotation: buyQuotation),
                    LimitDate(
                      buyQuotation: buyQuotation,
                      code: widget.code,
                      enterpriseCode: widget.enterpriseCode,
                    ),
                    gapSliverH8,
                    BuyersDropdown(
                      buyQuotation: buyQuotation,
                      enterpriseCode: widget.enterpriseCode,
                      code: widget.code,
                    ),
                    gapSliverH8,
                    ObservationField(
                      observationController: observationController,
                    ),
                    const SliverToBoxAdapter(child: Divider()),
                    Enterprises(
                      enterpriseCode: widget.enterpriseCode,
                      code: widget.code,
                      buyQuotation: buyQuotation,
                    ),
                    const SliverToBoxAdapter(child: Divider()),
                    SearchProductField(
                      enterpriseCode: widget.enterpriseCode,
                      code: widget.code,
                      searchValueController: searchValueController,
                      buyQuotation: buyQuotation,
                    ),
                    gapSliverH8,
                    ProductsItems(
                      buyQuotation: buyQuotation,
                      quantityControllers: quantityControllers,
                      enterpriseCode: widget.enterpriseCode,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        LoadingPage(
          providers: [
            saveBuyQuotationControllerProvider(
              widget.enterpriseCode,
              widget.code.toString(),
            ),
          ],
        ),
      ],
    );
  }
}
