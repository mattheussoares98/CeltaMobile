import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConfirmAndRequestButtons extends ConsumerWidget {
  final int enterpriseCode;
  final void Function(bool isRequest) confirmRequest;
  const ConfirmAndRequestButtons({
    super.key,
    required this.enterpriseCode,
    required this.confirmRequest,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Sizes.p8),
      child: Row(
        children: [
          Expanded(
            child: _ConfirmOrRequestButton(
              isRequest: true,
              confirmRequest: confirmRequest,
            ),
          ),
          gapW8,
          Expanded(
            child: _ConfirmOrRequestButton(
              isRequest: false,
              confirmRequest: confirmRequest,
            ),
          ),
        ],
      ),
    );
  }
}

class _ConfirmOrRequestButton extends StatelessWidget {
  final bool isRequest;
  final void Function(bool isRequest) confirmRequest;
  const _ConfirmOrRequestButton({
    required this.isRequest,
    required this.confirmRequest,
  });

  @override
  Widget build(BuildContext context) {
    return PrimaryButton(
      text: isRequest ? 'Solicitar'.hardcoded : 'Confirmar'.hardcoded,
      onPressed: () async {
        showAlertDialog(
          context: context,
          title: isRequest ? 'Solicitar?'.hardcoded : 'Confirmar?'.hardcoded,
          cancelActionText: 'Cancelar'.hardcoded,
          defaultActionText: 'Sim'.hardcoded,
          onOkPressed: () => confirmRequest(isRequest),
        );
      },
    );
  }
}
