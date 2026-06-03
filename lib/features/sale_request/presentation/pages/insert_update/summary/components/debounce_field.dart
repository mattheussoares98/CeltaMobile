import 'dart:async';

import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/sale_request/providers.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum DebounceFieldType { instructions, observations }

class DebounceField extends ConsumerStatefulWidget {
  final DebounceFieldType type;

  const DebounceField({super.key, required this.type});

  @override
  ConsumerState<DebounceField> createState() => _DebounceFieldState();
}

class _DebounceFieldState extends ConsumerState<DebounceField> {
  late final TextEditingController _controller;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    final args = ref.read(saleRequestArgsProvider);
    final controllerState = ref
        .read(saleRequestDetailsStateControllerProvider(args))
        .value;
    final initialValue = widget.type == DebounceFieldType.instructions
        ? controllerState?.instructions
        : controllerState?.observations;
    _controller = TextEditingController(text: initialValue ?? '');
  }

  void _onChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 600), () {
      final notifier = ref.read(insertUpdateStateControllerProvider.notifier);
      if (widget.type == DebounceFieldType.instructions) {
        notifier.updateInstructions(value);
      } else {
        notifier.updateObservations(value);
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isInstructions = widget.type == DebounceFieldType.instructions;

    return DefaultTextFormField(
      controller: _controller,
      labelText: isInstructions
          ? 'Instruções'.hardcoded
          : 'Observações'.hardcoded,
      hintText: isInstructions
          ? 'Instruções'.hardcoded
          : 'Observações'.hardcoded,
      maxLength: 400,
      maxLines: 5,
      textInputAction: isInstructions
          ? TextInputAction.done
          : TextInputAction.next,
      onChanged: _onChanged,
    );
  }
}
