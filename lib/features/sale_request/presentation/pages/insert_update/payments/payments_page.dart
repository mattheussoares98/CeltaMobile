import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/sale_request/presentation/pages/insert_update/payments/components/components.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PaymentsPage extends ConsumerWidget {
  const PaymentsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String? errorMessage = ref.watch(
      insertUpdateStateControllerProvider.select((s) {
        if (s.value?.customer == null) {
          return 'Informe o cliente'.hardcoded;
        } else if (s.value?.products?.isEmpty == true) {
          return 'Informe pelo menos um produto'.hardcoded;
        }
        return null;
      }),
    );

    if (errorMessage != null) {
      return Center(
        child: Text(
          errorMessage,
          style: context.theme.textTheme.titleSmall?.copyWith(
            fontStyle: FontStyle.italic,
            color: Colors.red,
          ),
        ),
      );
    }

    return const ResponsiveCenter(
      padding: EdgeInsets.all(Sizes.p8),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: IncrementAndDiscount()),
          NewPaymentSection(),
          PaymentsList(),
        ],
      ),
    );
  }
}
