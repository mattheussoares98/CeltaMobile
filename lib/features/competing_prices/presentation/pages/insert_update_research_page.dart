import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/validators/validators.dart';
import 'package:celta_inventario/features/competing_prices/domain/entities/entities.dart';
import 'package:celta_inventario/features/competing_prices/presentation/controllers/controllers.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class InsertUpdateResearchPage extends ConsumerStatefulWidget {
  final ResearchEntity? research; //if is null, is inserting
  final int enterpriseCode;
  const InsertUpdateResearchPage({
    super.key,
    required this.research,
    required this.enterpriseCode,
  });

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
          enterpriseCode: widget.enterpriseCode,
        );
  }

  @override
  Widget build(BuildContext context) {
    bool isLoading = ref.watch(
      insertUpdateResearchControllerProvider.select((s) => s.isLoading),
    );

    ref.listen(insertUpdateResearchControllerProvider, (p, n) {
      n.doOnSuccess(p, () {
        context.pop();
        showToastMessage(
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              BaseText.headline(
                widget.research == null
                    ? 'Inserindo pesquisa'.hardcoded
                    : 'Editando pesquisa'.hardcoded,
              ),
              gapH32,
              BaseTextFormField(
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
              BaseTextFormField(
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
      ),
    );
  }
}
