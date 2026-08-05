// lib/features/synchronizer/presentation/pages/details/components/selectable_actions/selectable_action.dart
import 'package:flutter/foundation.dart';

class SelectableAction {
  final String label;
  final VoidCallback? onPressed;

  const SelectableAction({
    required this.label,
    this.onPressed,
  });
}
