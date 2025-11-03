import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:celta_intelligence/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../commom_widgets/commom_widgets.dart';
import '../../../../constants/constants.dart';
import '../controllers/controllers.dart';
import 'components/components.dart.dart';

class LotPage extends ConsumerStatefulWidget {
  final int enterpriseCode;
  const LotPage({super.key, required this.enterpriseCode});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LotPageState();
}

class _LotPageState extends ConsumerState<LotPage> {
  int? selectedIndex;
  final quantityController = TextEditingController();
  final quantityFocusNode = FocusNode();

  void changeSelectedIndex(int index, double? quantity) {
    if (selectedIndex == index) {
      setState(() {
        selectedIndex = null;
      });
    } else {
      setState(() {
        selectedIndex = index;
      });
      Future.delayed(const Duration(milliseconds: 100), () {
        quantityFocusNode.requestFocus();
        quantityController.text = quantity.toString().toBrazilianNumber();
        quantityController.selection = TextSelection.fromPosition(
          TextPosition(offset: quantityController.text.length),
        );
      });
    }
  }

  @override
  void dispose() {
    quantityController.dispose();
    quantityFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AsyncValueWidget(
      value: ref.watch(lotStateControllerProvider(widget.enterpriseCode)),
      tryAgain: () {
        ref.invalidate(lotStateControllerProvider(widget.enterpriseCode));
      },
      data: (items) {
        if (items.isEmpty) {
          return Center(child: Text('Lote vazio'.hardcoded));
        }
        return Column(
          children: [
            Expanded(
              child: LotItems(
                items: items,
                selectedIndex: selectedIndex,
                changeSelectedIndex: changeSelectedIndex,
                quantityController: quantityController,
                enterpriseCode: widget.enterpriseCode,
                quantityFocusNode: quantityFocusNode,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                Sizes.p4,
                0,
                Sizes.p4,
                Sizes.p4,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: ConfirmOrRequestButton(
                      isRequest: true,
                      enterpriseCode: widget.enterpriseCode,
                    ),
                  ),
                  gapW8,
                  Expanded(
                    child: ConfirmOrRequestButton(
                      isRequest: false,
                      enterpriseCode: widget.enterpriseCode,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
