import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../core/domain/entities/entities.dart';
import '../../controllers/controllers.dart';
import 'products.dart';

class ProductsConferencePage extends ConsumerStatefulWidget {
  final int expeditionControlCode;
  final int stepCode;
  final EnterpriseEntity? selectedEnterprise;
  final String documentNumber;
  final int enterpriseCode;
  const ProductsConferencePage({
    super.key,
    required this.expeditionControlCode,
    required this.stepCode,
    required this.selectedEnterprise,
    required this.documentNumber,
    required this.enterpriseCode,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ProductsConferencePageState();
}

class _ProductsConferencePageState
    extends ConsumerState<ProductsConferencePage> {
  final searchValueController = TextEditingController();
  final focusNode = FocusNode();
  int currentIndex = 0;

  @override
  void dispose() {
    super.dispose();

    searchValueController.dispose();
    focusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pendingProductsAsync = ref.watch(
      pendingProductsStateControllerProvider(
        widget.expeditionControlCode,
        widget.selectedEnterprise?.name ?? '',
      ),
    );

    final pages = [
      PendingProductsPage(
        expeditionControlCode: widget.expeditionControlCode,
        focusNode: focusNode,
        searchValueController: searchValueController,
        selectedEnterprise: widget.selectedEnterprise,
        documentNumber: widget.documentNumber,
        enterpriseCode: widget.enterpriseCode,
        pendingProductsAsync: pendingProductsAsync,
      ),
      ConferedProductsPage(),
    ];
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            label: 'Pendentes'.hardcoded,
            icon: BadgeIcon(
              valid: null, //TODO change to a widget param
              cupertinoIcon: CupertinoIcons.exclamationmark_triangle,
              materialIcon: Icons.error,
            ),
          ),
          BottomNavigationBarItem(
            label: 'Conferidos'.hardcoded,
            icon: BadgeIcon(
              valid: null,
              cupertinoIcon: CupertinoIcons.checkmark_seal,
              materialIcon: Icons.verified_rounded,
            ),
          ),
        ],
      ),
    );
  }
}
