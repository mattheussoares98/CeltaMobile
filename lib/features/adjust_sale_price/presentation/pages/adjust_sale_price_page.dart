import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../commom_widgets/commom_widgets.dart';
import '../../../../constants/constants.dart';
import '../../../../core/domain/entities/entities.dart';
import '../../../enterprises/presentation/controllers/controllers.dart';
import '../../domain/entities/entities.dart';
import '../controllers/controllers.dart';
import 'components/components.dart';

class AdjustSalePricePage extends ConsumerStatefulWidget {
  final String plu;
  final int enterpriseCode;
  final ProductEntity? product;
  final EnterpriseEntity? enterprise;
  const AdjustSalePricePage({
    super.key,
    required this.plu,
    required this.enterpriseCode,
    required this.product,
    required this.enterprise,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AdjustSalePricePageState();
}

class _AdjustSalePricePageState extends ConsumerState<AdjustSalePricePage> {
  SaleType? selectedSaleType = SaleType.retail;
  PriceType? selectedPriceType = PriceType.retail;

  @override
  Widget build(BuildContext context) {
    final selectedProductAsync = ref.watch(
      selectedProductStateControllerProvider(
        widget.enterpriseCode,
        widget.plu,
        widget.product,
      ),
    );
    final selectedEnterprise = ref.watch(
      selectedEnterpriseStateControllerProvider,
    );

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 40,
        title: FittedBox(
          child: Text(
            selectedProductAsync.value == null
                ? ""
                : "(${selectedProductAsync.value!.PLU}) ${selectedProductAsync.value!.Name}",
          ),
        ),
      ),
      body: AsyncValueWidget(
        value: selectedProductAsync,
        tryAgain: () {
          ref.invalidate(
            selectedProductStateControllerProvider(
              widget.enterpriseCode,
              widget.plu,
              widget.product,
            ),
          );
        },
        data: (product) {
          return Padding(
            padding: const EdgeInsets.all(Sizes.p4),
            child: Column(
              children: [
                Text("Schedules"),
                Divider(),
                SalesTypeWidget(
                  selectedSaleType: selectedSaleType,
                  selectedEnterprise: selectedEnterprise,
                  onTap: (value) {
                    setState(() {
                      selectedSaleType = value;
                    });
                  },
                ),
                Divider(),
                PricesTypesWidget(
                  selectedPriceType: selectedPriceType,
                  onTap: (value) {
                    setState(() {
                      selectedPriceType = value;
                    });
                  },
                ),
                Divider(),
                Text("Replication params"),
                Divider(),
                Text("Start and end date"),
                Divider(),
                Text("product info"),
                Divider(),
              ],
            ),
          );
        },
      ),
    );
  }
}
