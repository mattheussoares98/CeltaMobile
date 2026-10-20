import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/widgets/address/address.dart';
import 'package:celta_inventario/features/competing_prices/domain/entities/entities.dart';
import 'package:celta_inventario/features/competing_prices/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/competing_prices/presentation/pages/insert_update_concurrent/components/components.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
  final formKey = GlobalKey<FormState>();
  AddressEntity? newAddress;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        if (widget.concurrentUpdating != null) {
          nameController.text = widget.concurrentUpdating!.Name!;
          observationController.text =
              widget.concurrentUpdating!.Observation ?? '';

          setState(() {
            newAddress = widget.concurrentUpdating!.Address;
          });
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

  Future<void> insertUpdate() async {
    if (formKey.currentState?.validate() != true) {
      return;
    }

    await ref
        .read(concurrentsStateControllerProvider.notifier)
        .insertUpdate(
          concurrentCode: widget.concurrentUpdating?.ConcurrentCode,
          name: nameController.text,
          observation: observationController.text,
          address: newAddress,
        );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(concurrentsStateControllerProvider, (p, n) {
      n.showAlertDialogOnError(context);
      n.doOnSuccess(p, () {
        context.pop();
        showToastMessage(
          context.l10n.competitorSaved(
            widget.concurrentUpdating == null ? 'create' : 'update',
          ),
        );
      });
    });
    return Padding(
      padding: const EdgeInsets.all(Sizes.p8),
      child: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              BaseText.headline(
                widget.concurrentUpdating == null
                    ? context.l10n.creatingCompetitor
                    : context.l10n.editingCompetitor,
                textAlign: TextAlign.center,
              ),
              gapH16,
              NameField(
                nameController: nameController,
                observationFocusNode: observationFocusNode,
              ),
              gapH8,
              ObservationsField(
                observationFocusNode: observationFocusNode,
                observationController: observationController,
                insertUpdate: insertUpdate,
              ),
              gapH8,
              AddressDetails(address: newAddress),
              const Divider(),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(Sizes.p8),
                  child: Column(
                    children: [
                      BaseText.headline(
                        context.l10n.editAddress,
                        textAlign: TextAlign.center,
                      ),
                      gapH8,
                      AddressForm(
                        module: Modules.competingPrices,
                        addAddress: (value) async {
                          setState(() {
                            newAddress = value;
                          });
                          return true;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              gapH32,
              SizedBox(
                width: 200,
                child: PrimaryButton(
                  text: widget.concurrentUpdating == null
                      ? context.l10n.insert
                      : context.l10n.change,
                  onPressed: insertUpdate,
                  isLoading: ref.watch(
                    concurrentsStateControllerProvider.select(
                      (s) => s.isLoading,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
