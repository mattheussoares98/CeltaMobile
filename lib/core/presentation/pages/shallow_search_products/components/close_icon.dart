import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/models.dart';

class CloseIcon extends StatelessWidget {
  final TextEditingController controller;
  const CloseIcon({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;
    return IconButton(
      icon: Icon(isIOS ? CupertinoIcons.xmark : Icons.close),
      onPressed: () => context.pop(
        TappedProductModel(
          codigoInternoProEmb: null,
          textField: controller.text,
          closedShallowPageType: ClosePageAction.cancel,
        ),
      ),
    );
  }
}
