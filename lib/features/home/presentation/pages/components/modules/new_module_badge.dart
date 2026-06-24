import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';

class MessgeBadge extends StatelessWidget {
  final String message;
  const MessgeBadge({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
        child: Container(
          color: Colors.red,
          padding: const EdgeInsets.symmetric(
            vertical: Sizes.p4,
            horizontal: Sizes.p16,
          ),
          child: Text(
            message,
            style: context.theme.textTheme.titleSmall?.copyWith(
              color: Colors.white,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ),
    );
  }
}
