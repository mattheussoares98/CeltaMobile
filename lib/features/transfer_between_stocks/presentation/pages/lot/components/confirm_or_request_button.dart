import 'package:celta_inventario/utils/utils.dart';
import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
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
      padding: const EdgeInsets.only(bottom: Sizes.p16),
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
      text: isRequest ? context.l10n.request : context.l10n.confirm,
      onPressed: () async {
        final confirmed = await showAlertDialog(
          context: context,
          title: isRequest
              ? context.l10n.request2
              : context.l10n.confirmQuestion,
          cancelActionText: context.l10n.cancel,
          defaultActionText: context.l10n.yes,
        );

        if (confirmed != true || !context.mounted) return;
        confirmRequest(isRequest);
      },
    );
  }
}
