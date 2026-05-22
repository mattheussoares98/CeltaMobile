import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/buy_request/presentation/controllers/controllers.dart';

class EnterpriseCodeAndProductName extends ConsumerWidget {
  final ProductEntity product;
  final int enterpriseCode;
  const EnterpriseCodeAndProductName({
    super.key,
    required this.product,
    required this.enterpriseCode,
  });

  static const List<Color> _enterpriseColors = [
    Colors.blue,
    Colors.teal,
    Colors.orange,
    Colors.purple,
    Colors.indigo,
    Colors.brown,
    Colors.pink,
    Colors.cyan,
  ];
  Color _getEnterpriseColor(int? code) {
    if (code == null) return Colors.grey;
    // Modulo operator ensures we stay within the list bounds
    return _enterpriseColors[code % _enterpriseColors.length];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendingAsync = ref.watch(
      pendingBuyRequestStateControllerProvider(enterpriseCode),
    );
    final correspondentEnterprise = pendingAsync.value?.selectedEnterprises
        ?.firstWhere((e) => e.Code == product.EnterpriseCode);

    final theme = Theme.of(context);

    return TitleAndSubTitle(
      title: null,
      subTitle:
          '(${correspondentEnterprise?.PersonalizedCode}) - ${correspondentEnterprise?.name}',
      subTitleStyle: theme.textTheme.titleMedium?.copyWith(
        color: _getEnterpriseColor(product.EnterpriseCode),
      ),
    );
  }
}
