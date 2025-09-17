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
  bool? isSelectedClass = false;
  bool? isSelectedGrid = false;
  bool? isSelectedOperationalGrouping = false;
  bool? isSelectedPackings = false;
  List<ReplicationTypes> replications = [ReplicationTypes.packings];

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
          replications.addAll([
            if (product?.IsFatherOfGrate == true ||
                product?.IsChildOfGrate == true)
              ReplicationTypes.grid,
            if (product?.InClass == true) ReplicationTypes.classess,
            if (selectedEnterprise?.EnterpriseParticipateEnterpriseGroup ==
                true)
              ReplicationTypes.operationalGrouping,
          ]);
          return ResponsiveScrollableWidget(
            padding: Sizes.p4,
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
                ReplicationTypesWidget(
                  replications: replications,
                  isSelectedClass: isSelectedClass,
                  isSelectedGrid: isSelectedGrid,
                  isSelectedOperationalGrouping: isSelectedOperationalGrouping,
                  isSelectedPackings: isSelectedPackings,
                  onChanged: (replication) {
                    //TODO ask gemini to make something easier
                    //TODO test using products that has all replications
                    setState(() {
                      if (replication == ReplicationTypes.classess) {
                        isSelectedClass = !isSelectedClass!;
                      } else if (replication == ReplicationTypes.grid) {
                        isSelectedGrid = !isSelectedGrid!;
                      } else if (replication ==
                          ReplicationTypes.operationalGrouping) {
                        isSelectedOperationalGrouping =
                            !isSelectedOperationalGrouping!;
                      } else if (replication == ReplicationTypes.packings) {
                        isSelectedPackings = !isSelectedPackings!;
                      }
                    });
                  },
                ),
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
