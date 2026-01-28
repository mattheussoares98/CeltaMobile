import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../../../../utils/utils.dart';
import '../../controllers/controllers.dart';

class LastSavedRequestsNumbers extends ConsumerWidget {
  const LastSavedRequestsNumbers({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lastSavedRequestNumber = ref.watch(
      pendingBuyRequestStateControllerProvider.select(
        (s) => s.value?.lastSavedRequestNumber,
      ),
    );

    if (lastSavedRequestNumber == null) {
      return const SizedBox.shrink();
    }

    final screenWidth = MediaQuery.sizeOf(context).width;
    final List<int> requestCodes = _extractListFromParentheses(
      lastSavedRequestNumber,
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: Sizes.p8),
      child: TitleAndSubTitle(
        title:
            'Último(s) pedido(s) ${screenWidth > Breakpoint.tablet ? "salvo(s)" : ""}'
                .hardcoded,
        subTitle: requestCodes.join('|'),
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
