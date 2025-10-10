import 'package:celta_intelligence/utils/utils.dart';
import 'package:flutter/material.dart';

class TitleAndSubTitle extends StatelessWidget {
  final String? title;
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

    String? getSubtitleText() {
      if (subTitle == null) {
        return null;
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
    final subtitleText = getSubtitleText();

    return RichText(
      textHeightBehavior: const TextHeightBehavior(
        applyHeightToFirstAscent: false,
        applyHeightToLastDescent: false,
      ),
      text: TextSpan(
        children: [
          if (!showErrorMessage && title != null)
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
          if (subtitleText != null)
            TextSpan(
              text: subTitleIsNumber
                  ? subtitleText.toBrazilianNumber(2, false)
                  : subtitleText,
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
