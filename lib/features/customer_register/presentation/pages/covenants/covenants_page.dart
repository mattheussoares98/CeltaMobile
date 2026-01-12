import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:celta_intelligence/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../../../../core/domain/entities/entities.dart';
import '../../../domain/entities/entities.dart';
import '../../controllers/controllers.dart';
import 'components/components.dart';

class CovenantsPage extends ConsumerStatefulWidget {
  const CovenantsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CovenantsPageState();
}

class _CovenantsPageState extends ConsumerState<CovenantsPage> {
  int? selectedIndex;
  final formKey = GlobalKey<FormState>();
  final limitController = TextEditingController();
  final limitFocusNode = FocusNode();

  @override
  void dispose() {
    super.dispose();

    limitController.dispose();
    limitFocusNode.dispose();
  }

  void changeSelectedIndex(int? index) {
    if (selectedIndex == index || index == null) {
      setState(() {
        selectedIndex = null;
      });
    } else {
      setState(() {
        selectedIndex = index;
      });
      Future.delayed(const Duration(milliseconds: 100), () {
        limitFocusNode.requestFocus();
      });
    }
  }

  void bindCovenant(CovenantEntity covenant) async {
    final customer = await ref.read(customerStateControllerProvider.future);

    if (customer == null) {
      return;
    }

    if (formKey.currentState?.validate() != true) {
      return;
    }

    ref
        .read(customerStateControllerProvider.notifier)
        .updateCustomer(
          customer.copyWith(
            CustomerCovenants: [
              ...?customer.CustomerCovenants,
              CustomerCovenantEntity(
                covenant: CovenantInfoEntity(
                  Code: covenant.Codigo_Convenio?.toInt() ?? 0,
                  PersonalizedCode: covenant.CodigoLegado_Convenio.toString(),
                  Name: covenant.Nome_Convenio ?? '',
                ),
                LimitOfPurchase: double.tryParse(limitController.text),
                Matriculate: '',
              ),
            ],
          ),
        );

    limitController.clear();
    changeSelectedIndex(null);
  }

  @override
  Widget build(BuildContext context) {
    final customer = ref.watch(customerStateControllerProvider).value;
    final covenantsAsync = ref.watch(covenantsStateControllerProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Convênios'.hardcoded)),
      body: AsyncValueWidget(
        value: covenantsAsync,
        tryAgain: () => ref.invalidate(covenantsStateControllerProvider),
        data: (covenants) {
          final notBindedCovenants = covenants!
              .where(
                (e) =>
                    customer?.CustomerCovenants
                        ?.where(
                          (x) => e.Codigo_Convenio?.toInt() == x.covenant?.Code,
                        )
                        .toList()
                        .isEmpty !=
                    false,
              )
              .toList();

          return Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Sizes.p4),
              child: ResponsiveScrollableWidget(
                isSliverPage: true,
                child: CustomScrollView(
                  slivers: [
                    if (notBindedCovenants.isNotEmpty)
                      NotBindedCovenants(
                        notBindedCovenants: notBindedCovenants,
                        changeSelectedIndex: changeSelectedIndex,
                        selectedIndex: selectedIndex,
                        bindCovenant: bindCovenant,
                        limitController: limitController,
                        limitFocusNode: limitFocusNode,
                      ),
                    if (customer?.CustomerCovenants != null &&
                        customer!.CustomerCovenants!.isNotEmpty) ...[
                      const BindedCovenants(),
                    ],
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
