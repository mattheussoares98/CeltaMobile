import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:celta_intelligence/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../../../../core/domain/entities/entities.dart';
import '../../controllers/controllers.dart';
import 'components/components.dart';

class AddressPage extends ConsumerStatefulWidget {
  const AddressPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddressPageState();
}

class _AddressPageState extends ConsumerState<AddressPage> {
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
          getAddressByCepControllerProvider.future,
        );
        if (address != null) {
          setState(() => showAllFields = true);
          addressController.text = address.Address;
          districtController.text = address.District;
          cityController.text = address.City;
          complementController.text = address.Complement ?? '';
          referenceController.text = address.Reference ?? '';

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
        .read(getAddressByCepControllerProvider.notifier)
        .getAddress(zipController.text);
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

  void addAddress() async {
    final customer = await ref.read(customerStateControllerProvider.future);

    if (formKey.currentState?.validate() != true || customer == null) {
      return;
    }

    if (customer.Addresses?.any(
          (e) =>
              e.Zip == zipController.text && e.Number == numberController.text,
        ) ??
        false) {
      showSnackBarMessage(
        context,
        'Esse endereço já foi inserido'.hardcoded,
        backgroundColor: Colors.red,
      );

      return;
    }

    ref
        .read(customerStateControllerProvider.notifier)
        .updateCustomer(
          customer.copyWith(
            Addresses: [
              ...?customer.Addresses,
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
            ],
          ),
        );
    setState(() {
      showAllFields = false;
    });
    ref.invalidate(getAddressByCepControllerProvider);
    clearFields(clearZip: true);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(getAddressByCepControllerProvider, (p, n) {
      if (n.hasError) {
        clearFields(clearZip: false);
      }
      n.showSnackbarOnError(
        context,
        previous: p,
        message: 'Ocorreu um erro não esperado. Tente novamente'.hardcoded,
      );
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
    final isLoading = ref.watch(getAddressByCepControllerProvider).isLoading;

    return Scaffold(
      appBar: AppBar(title: Text('Endereços'.hardcoded)),
      body: Form(
        key: formKey,
        child: ResponsiveScrollableWidget(
          child: Column(
            children: [
              Column(
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
                        Expanded(
                          child: CityField(cityController: cityController),
                        ),
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
              const InformedAddressess(),
            ],
          ),
        ),
      ),
    );
  }
}
