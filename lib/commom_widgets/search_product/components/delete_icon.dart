import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../mixin/mixin.dart';
import 'components.dart';

class DeleteIcon extends ConsumerStatefulWidget {
  final bool isLoading;
  final TextEditingController searchValueController;
  final FocusNode? focusNode;
  const DeleteIcon({
    super.key,
    required this.isLoading,
    required this.searchValueController,
    required this.focusNode,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DeleteIconState();
}

class _DeleteIconState extends ConsumerState<DeleteIcon>
    with DefaultSearchProductsMixin {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DefaultIcon(
      onPress: widget.isLoading
          ? null
          : () => onTapDeleteIcon(
              controller: widget.searchValueController,
              focusNode: widget.focusNode,
            ),
      materialIcon: Icons.delete,
      cupertinoIcon: CupertinoIcons.delete,
      iconColor: widget.isLoading ? theme.disabledColor : Colors.red,
    );
  }
}
