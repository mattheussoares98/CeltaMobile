import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../../../../core/domain/entities/entities.dart';
import '../../controllers/controllers.dart';
import 'components/components.dart';

class IdentificationPage extends ConsumerWidget {
  final TextEditingController supplierController;
  final GlobalKey<FormState> identificationFormKey;
  const IdentificationPage({
    super.key,
    required this.supplierController,
    required this.identificationFormKey,
  });

  static final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final suppliersState = ref.watch(
      supplierStateControllerProvider(SearchSupplierType.buyRequest),
    );

    return Scaffold(
      appBar: AppBar(title: Text('Identificação'.hardcoded)),
      body: ResponsiveScrollableWidget(
        child: Form(
          key: identificationFormKey,
          child: Column(
            children: [
              BuyersDropdown(),
              gapH8,
              RequestTypeDropdown(),
              gapH8,
              SuppliersItems(
                supplierController: supplierController,
                suppliersState: suppliersState,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
