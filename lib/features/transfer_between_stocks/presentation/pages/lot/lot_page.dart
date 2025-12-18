import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../controllers/controllers.dart';
import 'components/components.dart';

class LotPage extends ConsumerWidget {
  final int enterpriseCode;
  final TextEditingController lotQuantityController;
  final FocusNode lotQuantityFocusNode;
  const LotPage({
    super.key,
    required this.enterpriseCode,
    required this.lotQuantityController,
    required this.lotQuantityFocusNode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AsyncValueWidget(
      value: ref.watch(lotStateControllerProvider(enterpriseCode)),
      tryAgain: () {
        ref.invalidate(lotStateControllerProvider(enterpriseCode));
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
                quantityController: lotQuantityController,
                enterpriseCode: enterpriseCode,
                quantityFocusNode: lotQuantityFocusNode,
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
                      enterpriseCode: enterpriseCode,
                    ),
                  ),
                  gapW8,
                  Expanded(
                    child: ConfirmOrRequestButton(
                      isRequest: false,
                      enterpriseCode: enterpriseCode,
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
