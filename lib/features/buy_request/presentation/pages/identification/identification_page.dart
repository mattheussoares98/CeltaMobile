import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../../../../core/domain/entities/entities.dart';
import '../../../../../core/presentation/controllers/supplier/supplier.dart';
import 'components/components.dart';

class IdentificationPage extends ConsumerStatefulWidget {
  final TextEditingController supplierController;
  final GlobalKey<FormState> identificationFormKey;
  final List<SupplierEntity> suppliers;
  const IdentificationPage({
    super.key,
    required this.supplierController,
    required this.identificationFormKey,
    required this.suppliers,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _IdentificationPageState();
}

class _IdentificationPageState extends ConsumerState<IdentificationPage> {
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    formKey.currentState?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final suppliersState = ref.watch(
      supplierStateControllerProvider(SearchSupplierType.buyRequest),
    );

    return Scaffold(
      body: Form(
        key: widget.identificationFormKey,
        child: ResponsiveScrollableWidget(
          isSliverPage: true,
          child: CustomScrollView(
            slivers: [
              const BuyersDropdown(),
              gapSliverH8,
              const RequestTypeDropdown(),
              gapSliverH8,
              SupplierSearcher(
                supplierController: widget.supplierController,
                suppliersState: suppliersState,
              ),
              SupplierItems(
                suppliersState: suppliersState,
                suppliers: widget.suppliers,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
