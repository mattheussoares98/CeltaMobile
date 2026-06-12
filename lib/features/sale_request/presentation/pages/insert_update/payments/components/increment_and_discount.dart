import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class IncrementAndDiscount extends ConsumerWidget {
  const IncrementAndDiscount({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (financialIncrement, financialDiscount) = ref.watch(
      insertUpdateStateControllerProvider.select(
        (s) => (s.value?.financialIncrement, s.value?.financialDiscount),
      ),
    );
    return Column(
      children: [
        _Item(valueType: financialIncrement, isIncrement: true),
        _Item(valueType: financialDiscount, isIncrement: false),
      ],
    );
  }
}

class _Item extends StatelessWidget {
  final BSFValueTypeEntity? valueType;
  final bool isIncrement;
  const _Item({required this.valueType, required this.isIncrement});

  @override
  Widget build(BuildContext context) {
    final title = isIncrement
        ? 'Acréscimo financeiro'.hardcoded
        : 'Desconto financeiro'.hardcoded;
    if ((valueType?.value ?? 0) == 0) {
      return const SizedBox.shrink();
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(Sizes.p8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TitleAndSubTitle(
              title: title,
              subTitle:
                  '${valueType?.value?.toString().toBrazilianNumber()} ${valueType?.type?.symbol ?? ''}',
            ),
          ],
        ),
      ),
    );
  }
}
