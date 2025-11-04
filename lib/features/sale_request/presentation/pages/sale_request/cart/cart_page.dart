import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../controllers/controllers.dart';
import 'components/components.dart';

class CartPage extends ConsumerStatefulWidget {
  const CartPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CartPageState();
}

class _CartPageState extends ConsumerState<CartPage> {
  int? selectedIndex;

  void changeSelectedIndex(int? index) {
    if (selectedIndex == index) {
      setState(() {
        selectedIndex = null;
      });
    } else {
      setState(() {
        selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final products = ref.watch(
      pendingSaleRequestStateControllerProvider.select(
        (state) => state.value?.cart.values.toList() ?? [],
      ),
    );

    return ResponsiveListFlow(
      itemCount: products.length,
      itemBuilder: (_, index) {
        final product = products[index];

        return Card(
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () {
              changeSelectedIndex(index);
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                Sizes.p8,
                Sizes.p8,
                0,
                Sizes.p8,
              ),
              child: Column(
                children: [
                  NamePluAndDeleteButton(product: product),
                  gapH4,
                  Values(
                    product: product,
                    index: index,
                    selectedIndex: selectedIndex,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
