import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../../domain/entities/entities.dart';
import 'components/components.dart';

class ConferedProductsPage extends ConsumerWidget {
  final VoidCallback onRefresh;
  final AsyncValue<ExpeditionConferenceState> pendingProductsAsync;
  const ConferedProductsPage({
    super.key,
    required this.onRefresh,
    required this.pendingProductsAsync,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text('Produtos Conferidos'.hardcoded)),
      body: Padding(
        padding: const EdgeInsets.all(Sizes.p8),
        child: AsyncValueWidget(
          value: pendingProductsAsync,
          tryAgain: onRefresh,
          data: (conferenceState) {
            if (conferenceState.scannedProducts.isEmpty) {
              return Center(
                child: Text('Nenhum produto conferido até o momento'.hardcoded),
              );
            }

            return ListView.builder(
              itemCount: conferenceState.scannedProducts.length,
              itemBuilder: (_, index) {
                final product = conferenceState.scannedProducts[index];
                return ProductItem(product: product);
              },
            );
          },
        ),
      ),
    );
  }
}
