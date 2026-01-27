import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
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
  int?
  selectedIndex; //I didnt create another controller because normally the list will be small
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
    limitController.clear();
    if (limitFocusNode.hasFocus) {
      limitFocusNode.unfocus();
    }

    if (selectedIndex == index || index == null) {
      setState(() {
        selectedIndex = null;
      });
    } else {
      setState(() {
        selectedIndex = index;
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
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

    ref.read(customerStateControllerProvider.notifier).updateCustomerCovenants([
      ...?customer.CustomerCovenants,
      CustomerCovenantEntity(
        covenant: CovenantInfoEntity(
          Code: covenant.CodigoInterno_Convenio?.toInt() ?? 0,
          PersonalizedCode: covenant.CodigoLegado_Convenio.toString(),
          Name: covenant.Nome_Convenio ?? '',
        ),
        LimitOfPurchase: limitController.text.toDouble(),
        Matriculate: '',
      ),
    ]);

    limitController.clear();
    changeSelectedIndex(null);
  }

  @override
  Widget build(BuildContext context) {
    final customerCovenants = ref.watch(
      customerStateControllerProvider.select((s) => s.value?.CustomerCovenants),
    );
    final covenantsAsync = ref.watch(covenantsStateControllerProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Convênios'.hardcoded)),
      body: AsyncValueWidget(
        value: covenantsAsync,
        tryAgain: () => ref.invalidate(covenantsStateControllerProvider),
        data: (covenants) {
          return Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Sizes.p4),
              child: ResponsiveScrollableWidget(
                isSliverPage: true,
                child: CustomScrollView(
                  physics: const ClampingScrollPhysics(),
                  slivers: [
                    NotBindedCovenants(
                      covenants: covenants,
                      changeSelectedIndex: changeSelectedIndex,
                      selectedIndex: selectedIndex,
                      bindCovenant: bindCovenant,
                      limitController: limitController,
                      limitFocusNode: limitFocusNode,
                    ),
                    if (customerCovenants != null &&
                        customerCovenants.isNotEmpty) ...[
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
