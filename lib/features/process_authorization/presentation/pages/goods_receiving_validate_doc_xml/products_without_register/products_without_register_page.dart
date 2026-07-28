import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/process_authorization/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/process_authorization/presentation/pages/goods_receiving_validate_doc_xml/goods_receiving_validate_doc_xml.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductsWithoutRegisterPage extends ConsumerWidget {
  final int processCode;
  const ProductsWithoutRegisterPage({super.key, required this.processCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = gRDocFiscalNoteDifferencesStateControllerProvider(
      processCode,
    );
    final productsWithoutRegister = ref.watch(
      provider.select((s) => s.value?.productsWithoutCadaster ?? []),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Sizes.p8),
      child: ResponsiveListFlow(
        itemCount: productsWithoutRegister.length,
        itemBuilder: (context, index) {
          final product = productsWithoutRegister[index];
          return Card(
            clipBehavior: .hardEdge,
            child: InkWell(
              onTap: product.code == null
                  ? null
                  : () {
                      showModalPage(
                        SearchProductToLink(
                          processCode: processCode,
                          productCode: product.code!,
                        ),
                        context,
                      );
                    },
              child: Padding(
                padding: const EdgeInsets.all(Sizes.p8),
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    if (product.ean?.isNotEmpty ?? false)
                      TitleAndSubTitle(
                        title: 'EAN'.hardcoded,
                        subTitle: product.ean,
                      ),
                    if (product.reference?.isNotEmpty ?? false)
                      TitleAndSubTitle(
                        title: 'Referência'.hardcoded,
                        subTitle: product.reference,
                      ),
                    if (product.quantity != null)
                      TitleAndSubTitle(
                        title: 'Qtd contagem'.hardcoded,
                        subTitle: product.quantity,
                      ),
                    if (product.observations?.isNotEmpty ?? false)
                      TitleAndSubTitle(
                        title: 'Observações'.hardcoded,
                        subTitle: product.observations,
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
