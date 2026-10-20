part of 'sale_request_with_errors_items.dart';

class AssociateProductPage extends ConsumerStatefulWidget {
  const AssociateProductPage({
    super.key,
    required this.errorKey,
    required this.productNotFound,
  });
  final String errorKey;
  final EcSaleRequestProductNotFoundDetailEntity productNotFound;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ProductsWithoutRegisterPageState();
}

class _ProductsWithoutRegisterPageState
    extends ConsumerState<AssociateProductPage> {
  final searchController = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    searchController.dispose();
    super.dispose();
  }

  static const recordsByPage = 20;

  @override
  Widget build(BuildContext context) {
    ref.observeLoading([linkProductWithoutRegisterControllerProvider]);
    ref.listen(linkProductWithoutRegisterControllerProvider, (p, n) {
      n.showAlertDialogOnError(context);
    });
    return Padding(
      padding: const EdgeInsets.all(Sizes.p8),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Align(
            child: BaseText.title(
              context.l10n.searchForAndSelectTheProductToLink,
            ),
          ),
          gapH16,
          TitleAndSubTitle(
            title: context.l10n.websiteCode,
            subTitle: widget.productNotFound.eCommerceCode,
          ),
          TitleAndSubTitle(
            title: context.l10n.product,
            subTitle: widget.productNotFound.name,
          ),
          gapH16,
          BaseTextFormField(
            controller: searchController,
            hintText: context.l10n.name,
            labelText: context.l10n.viewProduct,
            onFieldSubmitted: (value) => ref
                .read(shallowProductsStateControllerProvider.notifier)
                .load(value, recordsByPage: recordsByPage),
            //! using shallow because it does not require enterpriseCode
            onChanged: (value) {
              if (_debounce?.isActive ?? false) _debounce!.cancel();
              _debounce = Timer(const Duration(milliseconds: 600), () {
                ref
                    .read(shallowProductsStateControllerProvider.notifier)
                    .load(value, recordsByPage: recordsByPage);
              });
            },
          ),
          AsyncValueWidget(
            value: ref.watch(shallowProductsStateControllerProvider),
            tryAgain: () =>
                ref.invalidate(shallowProductsStateControllerProvider),
            data: (products) {
              if (products?.isEmpty ?? false) {
                return Center(
                  child: BaseText.error(context.l10n.noProductsFound),
                );
              }
              return Expanded(
                child: ListView.builder(
                  itemCount: products?.length ?? 0,
                  itemBuilder: (context, index) {
                    final product = products![index];

                    return Card(
                      clipBehavior: .hardEdge,
                      child: InkWell(
                        onTap: () async {
                          final ok = await showAlertDialog(
                            context: context,
                            title: context.l10n.attention2,
                            content:
                                context.l10n.websiteProductToLink(
                                  product.Name ?? '',
                                ) +
                                context.l10n.productToLink(
                                  widget.productNotFound.name,
                                ) +
                                context.l10n.linkProduct,
                            defaultActionText: context.l10n.yes,
                            cancelActionText: context.l10n.no,
                          );

                          if (ok == true) {
                            final succeeds = await ref
                                .read(
                                  linkProductWithoutRegisterControllerProvider
                                      .notifier,
                                )
                                .link(
                                  productCode: product.ProductCode!,
                                  errorKey: widget.errorKey,
                                  productPackingCode:
                                      product.codigoInternoProEmb!,
                                  productNotFoundCode:
                                      widget.productNotFound.code,
                                );
                            if (succeeds && context.mounted) {
                              Navigator.of(context).pop();
                            }
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(Sizes.p8),
                          child: Column(
                            crossAxisAlignment: .start,
                            children: [
                              BaseRichText(
                                texts: [
                                  BaseText.title(
                                    product.PLU.toString(),
                                    color: context.theme.primaryColor,
                                  ),
                                  BaseText.title(' (${product.Name})'),
                                  BaseText(
                                    ' (${product.PackingAbbreviation} ${product.PackingQuantity.toString().toBrazilianNumber(3, true)})',
                                    color: context.theme.colorScheme.secondary,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
