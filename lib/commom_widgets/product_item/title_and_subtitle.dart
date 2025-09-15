import 'package:celta_intelligence/utils/utils.dart';
import 'package:flutter/material.dart';

class TitleAndSubTitle extends StatelessWidget {
  final String title;
  final dynamic subTitle;
  final String? emptyMessage;
  final TextStyle? titleStyle;
  final TextStyle? subTitleStyle;
  final bool? subTitleIsPrice;
  final bool? subTitleIsPercentage;
  const TitleAndSubTitle({
    super.key,
    required this.title,
    required this.subTitle,
    this.titleStyle,
    this.subTitleStyle,
    this.emptyMessage,
    this.subTitleIsPrice,
    this.subTitleIsPercentage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    bool showErrorMessage = false;
    bool subTitleIsNumber = subTitle is double || subTitle is int;

    if (subTitleIsNumber && emptyMessage != null) {
      if ((subTitle as double) == 0) {
        showErrorMessage = true;
      }
    }

    String getSubtitleText() {
      if (subTitleIsNumber && (subTitle as double) == -1) {
        return 'Sem permissão p/ visualizar';
      } else if (showErrorMessage) {
        return emptyMessage!;
      } else if (subTitleIsNumber) {
        return subTitle.toString().toBrazilianNumber();
      } else {
        return subTitle.toString();
      }
    }

    Color? getSubtitleColor() {
      if (showErrorMessage) {
        return Colors.red;
      } else if (subTitleIsNumber && (subTitle as double) <= 0) {
        return Colors.red;
      } else if (subTitleIsNumber && (subTitle as double) > 0) {
        return Colors.green;
      }
      return null;
    }

    final subtitleColor = getSubtitleColor();

    return RichText(
      textHeightBehavior: const TextHeightBehavior(
        applyHeightToFirstAscent: false,
        applyHeightToLastDescent: false,
      ),
      text: TextSpan(
        children: [
          if (!showErrorMessage)
            TextSpan(
              text: title,
              style: titleStyle ?? theme.textTheme.bodyMedium,
            ),
          if (subTitleIsPrice == true && !showErrorMessage)
            TextSpan(
              text: "R\$ ",
              style: (subTitleStyle ?? theme.textTheme.titleMedium)?.copyWith(
                color: subtitleColor,
                fontSize: 11,
              ),
            ),
          TextSpan(
            text: getSubtitleText(),
            style: (subTitleStyle ?? theme.textTheme.titleMedium)?.copyWith(
              color: subtitleColor,
            ),
          ),
          if (subTitleIsPercentage == true && !showErrorMessage)
            TextSpan(
              text: ' %',
              style: (subTitleStyle ?? theme.textTheme.titleMedium)?.copyWith(
                color: subtitleColor,
                fontSize: 11,
              ),
            ),
        ],
      ),
    );
  }
}
