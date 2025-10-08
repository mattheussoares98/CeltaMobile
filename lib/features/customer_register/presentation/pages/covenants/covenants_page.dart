import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:celta_intelligence/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../core/domain/entities/entities.dart';
import '../../../domain/entities/entities.dart';
import '../../controllers/controllers.dart';
import '../components/components.dart';
import 'components/components.dart';

class CovenantsPage extends ConsumerStatefulWidget {
  final AsyncValue<List<CovenantEntity>?> covenantsAsync;
  final TextEditingController limitController;
  final FocusNode limitFocusNode;
  final List<CustomerCovenantEntity> bindedCovenants;
  final CustomerEntity? customer;
  const CovenantsPage({
    super.key,
    required this.covenantsAsync,
    required this.limitController,
    required this.limitFocusNode,
    required this.bindedCovenants,
    required this.customer,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CovenantsPageState();
}

class _CovenantsPageState extends ConsumerState<CovenantsPage> {
  int? selectedIndex;
  final formKey = GlobalKey<FormState>();

  void changeSelectedIndex(int index) {
    if (selectedIndex == index) {
      setState(() {
        selectedIndex = null;
      });
    } else {
      setState(() {
        selectedIndex = index;
      });
      Future.delayed(Duration(milliseconds: 100), () {
        widget.limitFocusNode.requestFocus();
      });
    }
  }

  void bindCovenant(CovenantEntity covenant) {
    if (widget.customer == null) {
      return;
    }

    if (formKey.currentState?.validate() != true) {
      return;
    }

    ref
        .read(customerStateControllerProvider.notifier)
        .updateCustomer(
          widget.customer!.copyWith(
            CustomerCovenants: [
              ...widget.bindedCovenants,
              CustomerCovenantEntity(
                covenant: CovenantInfoEntity(
                  Code: covenant.Codigo_Convenio?.toInt() ?? 0,
                  PersonalizedCode: covenant.CodigoLegado_Convenio.toString(),
                  Name: covenant.Nome_Convenio ?? '',
                ),
                LimitOfPurchase: double.tryParse(widget.limitController.text),
                Matriculate: '99',
              ),
            ],
          ),
        );

    widget.limitController.clear();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Convênios'.hardcoded)),
      body: AsyncValueWidget(
        value: widget.covenantsAsync,
        tryAgain: () => ref.invalidate(covenantsStateControllerProvider),
        data: (covenants) {
          final notBindedCovenants = covenants!
              .where(
                (e) => !widget.bindedCovenants.any(
                  (b) => b.covenant?.Code == e.Codigo_Convenio?.toInt(),
                ),
              )
              .toList();

          return ResponsiveScrollableWidget(
            child: Column(
              children: [
                NotBindedCovenants(
                  formKey: formKey,
                  notBindedCovenants: notBindedCovenants,
                  changeSelectedIndex: changeSelectedIndex,
                  selectedIndex: selectedIndex,
                  bindCovenant: bindCovenant,
                  limitController: widget.limitController,
                  limitFocusNode: widget.limitFocusNode,
                ),
                if (widget.bindedCovenants.isNotEmpty) ...[
                  DefaultDivider('Convênios vinculados'),
                  BindedCovenants(bindedCovenants: widget.bindedCovenants),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
