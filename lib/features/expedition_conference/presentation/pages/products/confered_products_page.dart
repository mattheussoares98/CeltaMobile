import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../controllers/controllers.dart';
import 'components/components.dart';

class ConferedProductsPage extends ConsumerWidget {
  final int expeditionControlCode;
  const ConferedProductsPage({super.key, required this.expeditionControlCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scannedProducts = ref.watch(
      expeditionConferenceControllerProvider(
        expeditionControlCode,
      ).select((s) => s.value?.scannedProducts),
    );

    if (scannedProducts == null || scannedProducts.isEmpty) {
      return Center(
        child: Text('Nenhum produto conferido até o momento'.hardcoded),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(Sizes.p8),
      child: ResponsiveListFlow(
        itemCount: scannedProducts.length,
        itemBuilder: (_, index) {
          return ProductItem(
            key: ValueKey(scannedProducts[index].ProductPackingCode),
            index: index,
            expeditionControlCode: expeditionControlCode,
            isPending: false,
          );
        },
      ),
    );
  }
}
