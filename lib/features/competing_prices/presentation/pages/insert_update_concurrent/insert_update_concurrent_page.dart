import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../../../../localization/string_hardcoded.dart';
import '../../../domain/entities/entities.dart';

class InsertUpdateConcurrentPage extends ConsumerStatefulWidget {
  final ConcurrentEntity? concurrentUpdating;
  const InsertUpdateConcurrentPage({
    super.key,
    required this.concurrentUpdating,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UpdateConcurrentPageState();
}

class _UpdateConcurrentPageState
    extends ConsumerState<InsertUpdateConcurrentPage> {
  final nameController = TextEditingController();
  final observationController = TextEditingController();
  final observationFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        if (widget.concurrentUpdating != null) {
          nameController.text = widget.concurrentUpdating!.Name!;
          observationController.text =
              widget.concurrentUpdating!.Observation ?? '';
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    observationController.dispose();
    observationFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Sizes.p8),
      child: Column(
        children: [
          DefaultTitle(
            title: widget.concurrentUpdating == null
                ? 'Inserindo concorrente'.hardcoded
                : 'Alterando concorrente'.hardcoded,
          ),
          gapH16,
          DefaultTextFormField(
            controller: nameController,
            labelText: 'Nome'.hardcoded,
            hintText: 'Nome'.hardcoded,
            onFieldSubmitted: (_) => observationFocusNode.requestFocus(),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            maxLength: 50,
          ),
          gapH8,
          DefaultTextFormField(
            controller: observationController,
            focusNode: observationFocusNode,
            labelText: 'Observações'.hardcoded,
            hintText: 'Observações'.hardcoded,
            onFieldSubmitted: (_) {
              //TODO try to update. In success close the page and show snackbar and in error show alertDialog
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
            maxLength: 200,
          ),
          gapH32,
          SizedBox(
            width: 200,
            child: PrimaryButton(
              text: widget.concurrentUpdating == null
                  ? 'Inserir'.hardcoded
                  : 'Alterar'.hardcoded,
            ),
          ),
        ],
      ),
    );
  }
}
