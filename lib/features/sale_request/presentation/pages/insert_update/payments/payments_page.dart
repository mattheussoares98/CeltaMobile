import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/sale_request/presentation/pages/insert_update/payments/components/components.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PaymentsPage extends ConsumerStatefulWidget {
  const PaymentsPage({super.key});

  @override
  ConsumerState<PaymentsPage> createState() => _PaymentsPageState();
}

class _PaymentsPageState extends ConsumerState<PaymentsPage> {
  final creditCardController = TextEditingController();
  final portionsController = TextEditingController();
  final validityController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    creditCardController.dispose();
    portionsController.dispose();
    validityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveCenter(
      padding: const EdgeInsets.all(Sizes.p8),
      child: Form(
        key: formKey,
        child: Consumer(
          builder: (_, ref, _) {
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

            return CustomScrollView(
              slivers: [
                _NewPaymentSection(
                  creditCardController: creditCardController,
                  portionsController: portionsController,
                  validityController: validityController,
                  formKey: formKey,
                ),
                const PaymentsList(),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _NewPaymentSection extends ConsumerWidget {
  final TextEditingController creditCardController;
  final TextEditingController portionsController;
  final TextEditingController validityController;
  final GlobalKey<FormState> formKey;

  const _NewPaymentSection({
    required this.creditCardController,
    required this.portionsController,
    required this.validityController,
    required this.formKey,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isValidPayment = ref.watch(
      insertUpdateStateControllerProvider.select(
        (s) => s.value?.isPaymentValid ?? false,
      ),
    );

    if (isValidPayment) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    final totalLiquidAndPaidDifference = ref.watch(
      insertUpdateStateControllerProvider.select(
        (s) =>
            (s.value?.totalProductsLiquid ?? 0) -
            (s.value?.totalPayments ?? 0).abs(),
      ),
    );
    if (totalLiquidAndPaidDifference < 0) {
      return SliverToBoxAdapter(
        child: Text(
          'O total das formas de pagamento está maior que o total dos produtos!'
              .hardcoded,
          textAlign: TextAlign.center,
          style: context.theme.textTheme.titleSmall?.copyWith(
            color: Colors.red,
            fontStyle: FontStyle.italic,
          ),
        ),
      );
    }

    return SliverMainAxisGroup(
      slivers: [
        SliverToBoxAdapter(
          child: Text(
            'Nova forma de pagamento'.hardcoded,
            style: context.theme.textTheme.titleSmall?.copyWith(
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: TitleAndSubTitle(
            title: totalLiquidAndPaidDifference > 0
                ? 'Faltando'.hardcoded
                : 'Sobrando'.hardcoded,
            subTitle: totalLiquidAndPaidDifference.abs(),
            subTitleIsPrice: true,
            removeColon: true,
            subTitleStyle: context.theme.textTheme.titleMedium?.copyWith(
              color: Colors.red,
            ),
          ),
        ),
        gapSliverH8,
        const SliverToBoxAdapter(child: PaymentMethodDropdown()),
        gapSliverH8,
        const SliverToBoxAdapter(child: CovenantDropdown()),
        gapSliverH8,
        CreditCardFields(
          creditCardController: creditCardController,
          portionsController: portionsController,
          validityController: validityController,
        ),
        const PaymentConditionDropdown(),
        SliverToBoxAdapter(
          child: ValueFieldAndConfirmButton(
            formKey: formKey,
            creditCardController: creditCardController,
            portionsController: portionsController,
            validityController: validityController,
          ),
        ),
        const SliverToBoxAdapter(child: Divider()),
      ],
    );
  }
}
