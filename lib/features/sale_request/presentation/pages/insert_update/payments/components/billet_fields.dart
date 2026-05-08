import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../../constants/constants.dart';
import '../../../../../../../localization/string_hardcoded.dart';
import '../../../../../domain/entities/entities.dart';
import '../../../../controllers/controllers.dart';

class BilletFields extends ConsumerWidget {
  final int saleRequestId;
  const BilletFields({super.key, required this.saleRequestId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedBilletType = ref.watch(
      selectedPaymentTypeStateControllerProvider(
        saleRequestId,
      ).select((s) => s?.action?.type == PaymentFinalizationActionType.portion),
    );

    if (!selectedBilletType) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    return AsyncValueWidget(
      isSliver: true,
      value: ref.watch(paymentConditionsStateControllerProvider),
      tryAgain: () => ref.invalidate(paymentConditionsStateControllerProvider),
      data: (data) {
        if (data.isEmpty) {
          return SliverToBoxAdapter(
            child: Column(
              children: [
                Text(
                  'Nenhuma condição de pagamento disponível. Lembre-se que somente condições de pagamento com composição fixas aparecerão.'
                      .hardcoded,
                  textAlign: TextAlign.center,
                ),
                gapH8,
                PrimaryButton(
                  text: 'Carregar novamente'.hardcoded,
                  onPressed: () =>
                      ref.invalidate(paymentConditionsStateControllerProvider),
                ),
              ],
            ),
          );
        }

        return SliverList.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            final item = data[index];
            return Text(item.toString());
          },
        );
      },
    );
  }
}
