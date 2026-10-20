import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/buy_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LastSavedRequestsNumbers extends ConsumerWidget {
  final int enterpriseCode;
  const LastSavedRequestsNumbers({super.key, required this.enterpriseCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lastSavedRequestNumber = ref.watch(
      pendingBuyRequestStateControllerProvider(
        enterpriseCode,
      ).select((s) => s.value?.lastSavedRequestNumber),
    );

    if (lastSavedRequestNumber == null) {
      return const SizedBox.shrink();
    }

    final screenWidth = MediaQuery.sizeOf(context).width;
    final List<int> requestCodes = _extractListFromParentheses(
      lastSavedRequestNumber,
    );

    return FittedBox(
      child: TitleAndSubTitle(
        title: screenWidth > Breakpoint.tablet
            ? context.l10n.lastSavedOrders(requestCodes.length)
            : context.l10n.lastOrders(requestCodes.length),
        subTitle: requestCodes.join('|'),
        subTitleStyle: context.theme.textTheme.titleSmall,
      ),
    );
  }
}

/// Extracts items separated by '|' inside parentheses.
/// Example: "Orders (001 | 002)" -> ["001", "002"]
List<int> _extractListFromParentheses(String value) {
  final parenthesesContentPattern = RegExp(r'\(([^)]+)\)');
  // We look for the last match because the string might have
  // multiple parentheses like "Pedido(s) ... (001 | 002)"
  final matches = parenthesesContentPattern.allMatches(value);
  if (matches.isEmpty) return [];

  final content = matches.last.group(1);
  if (content == null) return [];

  return content
      .split('|')
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty)
      .map((e) => e.toInt()!)
      .toList();
}
