import 'package:flutter/material.dart';

class SelectableAction {
  final String label;
  final VoidCallback? onPressed;
  final Color? color;

  const SelectableAction({required this.label, this.onPressed, this.color});
}
