import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../commom_widgets/commom_widgets.dart';
import '../../../../constants/constants.dart';
import '../../../../localization/string_hardcoded.dart';
import '../../../../utils/utils.dart';
import '../../../domain/entities/entities.dart';
import '../../controllers/address/address.dart';
import 'address.dart';

class AddressForm extends ConsumerStatefulWidget {
  final Modules module;
  final Future<bool> Function(AddressEntity newAddress) addAddress;
  const AddressForm({
    super.key,
    required this.module,
    required this.addAddress,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddressFormState();
}

class _AddressFormState extends ConsumerState<AddressForm> {
  final formKey = GlobalKey<FormState>();
  final zipFormKey = GlobalKey<FormState>();

  final zipController = TextEditingController();
  final numberController = TextEditingController();
  final addressController = TextEditingController();
  final districtController = TextEditingController();
  final cityController = TextEditingController();
  final complementController = TextEditingController();
  final referenceController = TextEditingController();
  final numberFocusNode = FocusNode();
  final complementFocusNode = FocusNode();
  final referenceFocusNode = FocusNode();
  final zipFocusNode = FocusNode();

  bool showAllFields = false;
  BrazilStates? state;

  @override
  void dispose() {
    super.dispose();

    zipController.dispose();
    numberController.dispose();
    addressController.dispose();
    districtController.dispose();
    cityController.dispose();
    complementController.dispose();
    referenceController.dispose();
    numberFocusNode.dispose();
    complementFocusNode.dispose();
    referenceFocusNode.dispose();
    zipFocusNode.dispose();
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        final address = await ref.read(
          addressByCepStateControllerProvider(widget.module).future,
        );
        if (address != null) {
          setState(() => showAllFields = true);
          addressController.text = address.Address;
          districtController.text = address.District;
          cityController.text = address.City;
          complementController.text = address.Complement ?? '';
          referenceController.text = address.Reference ?? '';
          numberController.text = address.Number ?? '';
          zipController.text = address.Zip;

          final stateIndex = BrazilStates.values.indexWhere(
            (e) => e.name == address.State?.name,
          );
          if (stateIndex == -1) {
            return;
          } else {
            state = BrazilStates.values[stateIndex];
          }
        }
      }
    });
  }

  Future<void> seekAddress() async {
    if (zipFormKey.currentState?.validate() != true) return;
    ref
        .read(addressByCepStateControllerProvider(widget.module).notifier)
        .getAddress(zipController.text);
  }

  void addAddress() async {
    if (formKey.currentState?.validate() != true ||
        zipFormKey.currentState?.validate() != true) {
      return;
    }

    bool added = await widget.addAddress(
      AddressEntity(
        Zip: zipController.text,
        Address: addressController.text,
        Number: numberController.text,
        District: districtController.text,
        City: cityController.text,
        State: state,
        Complement: complementController.text,
        Reference: referenceController.text,
      ),
    );

    if (!added) {
      return;
    }

    setState(() {
      showAllFields = false;
    });
    ref.invalidate(addressByCepStateControllerProvider(widget.module));
    clearFields(clearZip: true);
  }

  void clearFields({required bool clearZip}) {
    if (clearZip) {
      zipController.clear();
    }
    addressController.clear();
    districtController.clear();
    cityController.clear();
    state = null;
    numberController.clear();
    referenceController.clear();
    complementController.clear();

    setState(() {
      showAllFields = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(
      addressByCepStateControllerProvider(
        widget.module,
      ).select((s) => s.isLoading),
    );

    ref.listen(addressByCepStateControllerProvider(widget.module), (p, n) {
      if (n.hasError) {
        clearFields(clearZip: false);
      }
      n.showSnackbarOnError(context, p);
      n.doOnSuccess(p, () {
        if (n.value == null) {
          return;
        }
        setState(() => showAllFields = true);
        addressController.text = n.value?.Address ?? '';
        districtController.text = n.value?.District ?? '';
        cityController.text = n.value?.City ?? '';

        final stateIndex = BrazilStates.values.indexWhere(
          (e) => e.name == n.value?.State?.name,
        );

        if (stateIndex == -1) {
          return;
        } else {
          state = BrazilStates.values[stateIndex];
        }
        Future.delayed(const Duration(milliseconds: 100), () {
          numberFocusNode.requestFocus();
        });
      });
    });

    return PopScope(
      onPopInvokedWithResult: (_, _) {
        ref
            .read(addressByCepStateControllerProvider(widget.module).notifier)
            .updateAddress(
              AddressEntity(
                Zip: zipController.text,
                Address: addressController.text,
                Number: numberController.text,
                District: districtController.text,
                City: cityController.text,
                State: state,
                Complement: complementController.text,
                Reference: referenceController.text,
              ),
            );
      },
      child: Form(
        key: formKey,
        child: Column(
          children: [
            Form(
              key: zipFormKey,
              child: ZipField(
                isLoading: isLoading,
                zipController: zipController,
                zipFocusNode: zipFocusNode,
                seekAddress: seekAddress,
                changeShowAllFields: (value) =>
                    setState(() => showAllFields = value),
              ),
            ),
            if (showAllFields) ...[
              gapH8,
              AddressField(addressController: addressController),
              gapH8,
              Row(
                children: [
                  Expanded(
                    child: DistrictField(
                      districtController: districtController,
                    ),
                  ),
                  gapW8,
                  Expanded(child: CityField(cityController: cityController)),
                ],
              ),
              gapH8,
              Row(
                children: [
                  Expanded(
                    flex: 60,
                    child: StatesDropDown(
                      isLoading: isLoading,
                      onChangeState: (state) =>
                          setState(() => this.state = state),
                      state: state,
                    ),
                  ),
                  gapW8,
                  Expanded(
                    flex: 40,
                    child: NumberField(
                      isLoading: isLoading,
                      numberController: numberController,
                      numberFocusNode: numberFocusNode,
                      complementFocusNode: complementFocusNode,
                    ),
                  ),
                ],
              ),
              gapH8,
              Row(
                children: [
                  Expanded(
                    child: ComplementField(
                      isLoading: isLoading,
                      complementController: complementController,
                      complementFocusNode: complementFocusNode,
                      referenceFocusNode: referenceFocusNode,
                    ),
                  ),
                  gapW8,
                  Expanded(
                    child: ReferenceField(
                      isLoading: isLoading,
                      referenceFocusNode: referenceFocusNode,
                      referenceController: referenceController,
                    ),
                  ),
                ],
              ),
              gapH32,
              PrimaryButton(
                text: 'Adicionar endereço'.hardcoded,
                onPressed: addAddress,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
