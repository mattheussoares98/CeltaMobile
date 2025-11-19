import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../commom_widgets/commom_widgets.dart';
import '../../../../constants/constants.dart';
import '../../../../core/validators/validators.dart';
import '../../../../localization/string_hardcoded.dart';
import '../../../../utils/utils.dart';
import '../../domain/entities/entities.dart';
import '../controllers/controllers.dart';

class InsertUpdateResearchPage extends ConsumerStatefulWidget {
  final ResearchEntity? research; //if is null, is inserting
  const InsertUpdateResearchPage({super.key, required this.research});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _InsertUpdateResearchPageState();
}

class _InsertUpdateResearchPageState
    extends ConsumerState<InsertUpdateResearchPage> {
  final nameController = TextEditingController();
  final observarionsController = TextEditingController();
  final observationsFocusNode = FocusNode();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();

    nameController.dispose();
    observarionsController.dispose();
    observationsFocusNode.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        if (widget.research != null) {
          nameController.text = widget.research!.Name!;
          observarionsController.text = widget.research!.Observation ?? '';
        }
      }
    });
  }

  void submit() async {
    if (formKey.currentState?.validate() != true) {
      return;
    }

    await ref
        .read(insertUpdateResearchControllerProvider.notifier)
        .insertUpdate(
          name: nameController.text,
          observations: observarionsController.text,
          researchCode: widget.research?.Code,
        );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    bool isLoading = ref.watch(
      insertUpdateResearchControllerProvider.select((s) => s.isLoading),
    );

    ref.listen(insertUpdateResearchControllerProvider, (p, n) {
      n.doOnSuccess(p, () {
        context.pop();
        showSnackBarMessage(
          context,
          'Pesquisa ${widget.research == null ? 'inserida' : 'alterada'} com sucesso'
              .hardcoded,
        );
      });
      n.showAlertDialogOnError(context);
    });

    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.all(Sizes.p8),
        child: Column(
          children: [
            Text(
              widget.research == null
                  ? 'Inserindo pesquisa'.hardcoded
                  : 'Editando pesquisa'.hardcoded,
              style: theme.textTheme.titleLarge,
            ),
            gapH32,
            DefaultTextFormField(
              controller: nameController,
              labelText: 'Nome'.hardcoded,
              hintText: 'Nome'.hardcoded,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              maxLength: 100,
              validator: FormValidators.compose([NonEmptyValidator()]),
              onFieldSubmitted: (_) {
                observationsFocusNode.requestFocus();
              },
            ),
            gapH8,
            DefaultTextFormField(
              controller: observarionsController,
              focusNode: observationsFocusNode,
              labelText: 'Observações'.hardcoded,
              hintText: 'Observações'.hardcoded,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              maxLength: 300,
              onFieldSubmitted: (_) => submit(),
            ),
            gapH32,
            SizedBox(
              width: 200,
              child: PrimaryButton(
                text: widget.research == null
                    ? 'Inserir'.hardcoded
                    : 'Editar'.hardcoded,
                onPressed: submit,
                isLoading: isLoading,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
