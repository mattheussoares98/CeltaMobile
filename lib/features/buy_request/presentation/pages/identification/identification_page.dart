import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../../../../core/domain/entities/entities.dart';
import '../../controllers/controllers.dart';
import 'components/components.dart';

class IdentificationPage extends ConsumerStatefulWidget {
  final TextEditingController supplierController;
  final GlobalKey<FormState> identificationFormKey;
  const IdentificationPage({
    super.key,
    required this.supplierController,
    required this.identificationFormKey,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _IdentificationPageState();
}

class _IdentificationPageState extends ConsumerState<IdentificationPage> {
  final formKey = GlobalKey<FormState>();
  List<SupplierEntity> suppliers = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        suppliers = await ref
            .read(
              supplierStateControllerProvider(
                SearchSupplierType.buyRequest,
              ).future,
            )
            .then((value) {
              return [...?value];
            });

        final pendingAsync = await ref.read(
          pendingBuyRequestStateControllerProvider.future,
        );

        if (pendingAsync.selectedSupplier != null &&
            suppliers.any(
                  (e) => e.Code == pendingAsync.selectedSupplier?.Code,
                ) !=
                true) {
          suppliers.add(pendingAsync.selectedSupplier!);
        }
      }
    });
  }

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
      appBar: AppBar(title: Text('Identificação'.hardcoded)),
      body: Form(
        key: widget.identificationFormKey,
        child: ResponsiveScrollableWidget(
          isSliverPage: true,
          child: CustomScrollView(
            slivers: [
              BuyersDropdown(),
              gapSliverH8,
              RequestTypeDropdown(),
              gapSliverH8,
              SupplierSearcher(
                supplierController: widget.supplierController,
                suppliersState: suppliersState,
              ),
              SupplierItems(
                suppliersState: suppliersState,
                suppliers: suppliers,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
