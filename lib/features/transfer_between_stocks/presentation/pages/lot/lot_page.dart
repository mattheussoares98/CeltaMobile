import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../constants/constants.dart';
import '../../controllers/controllers.dart';
import 'components/components.dart';

class LotPage extends ConsumerStatefulWidget {
  final int enterpriseCode;
  const LotPage({super.key, required this.enterpriseCode});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LotPageState();
}

class _LotPageState extends ConsumerState<LotPage> {
  final lotQuantityController = TextEditingController();
  final lotQuantityFocusNode = FocusNode();

  @override
  void dispose() {
    lotQuantityController.dispose();
    lotQuantityFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: CustomScrollView(
            slivers: [
              LotItems(
                quantityController: lotQuantityController,
                enterpriseCode: widget.enterpriseCode,
                quantityFocusNode: lotQuantityFocusNode,
              ),
              gapSliverH48,
            ],
          ),
        ),
        Consumer(
          builder: (_, ref, _) {
            final hasItemSelected = ref.watch(
              selectedLotIndexStateControllerProvider.select((s) => s != null),
            );

            if (hasItemSelected) {
              return const SizedBox.shrink();
            }

            final hasInsertedProduct = ref.watch(
              lotStateControllerProvider(
                widget.enterpriseCode,
              ).select((s) => s.value?.isNotEmpty == true),
            );

            if (!hasInsertedProduct) {
              return const SizedBox.shrink();
            }

            return Padding(
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
            );
          },
        ),
      ],
    );
  }
}
