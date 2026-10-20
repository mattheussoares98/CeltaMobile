import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';

class ReportedProblemImage extends StatelessWidget {
  final String title;
  final String url;
  final double aspectRatio;
  final BoxFit fit;
  final AlignmentGeometry alignment;
  const ReportedProblemImage({
    super.key,
    required this.title,
    required this.url,
    required this.aspectRatio,
    this.fit = BoxFit.cover,
    this.alignment = Alignment.center,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BaseText.title(title),
        gapH8,
        AspectRatio(
          aspectRatio: aspectRatio,
          child: Container(
            decoration: BoxDecoration(
              color: context.theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(Sizes.p8),
              border: Border.all(
                color: context.theme.colorScheme.outlineVariant,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(Sizes.p8),
              child: Image.network(
                url,
                fit: fit,
                alignment: alignment,
                errorBuilder: (_, _, _) =>
                    Center(child: BaseText(context.l10n.unableToLoadTheImage)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
