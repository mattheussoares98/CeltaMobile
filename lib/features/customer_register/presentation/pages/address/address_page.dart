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
  final TextEditingController zipController;
  final TextEditingController numberController;
  final TextEditingController addressController;
  final TextEditingController districtController;
  final TextEditingController cityController;
  final TextEditingController complementController;
  final TextEditingController referenceController;
  final FocusNode numberFocusNode;
  final FocusNode complementFocusNode;
  final FocusNode referenceFocusNode;
  final FocusNode zipFocusNode;
  final CustomerEntity? customer;

  const AddressPage({
    super.key,
    required this.zipController,
    required this.numberController,
    required this.addressController,
    required this.districtController,
    required this.cityController,
    required this.complementController,
    required this.referenceController,
    required this.numberFocusNode,
    required this.complementFocusNode,
    required this.referenceFocusNode,
    required this.zipFocusNode,
    required this.customer,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddressPageState();
}

class _AddressPageState extends ConsumerState<AddressPage> {
  final formKey = GlobalKey<FormState>();
  final zipFormKey = GlobalKey<FormState>();
  bool showAllFields = false;
  BrazilStates? state;

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
          widget.addressController.text = address.Address;
          widget.districtController.text = address.District;
          widget.cityController.text = address.City;
          widget.complementController.text = address.Complement ?? '';
          widget.referenceController.text = address.Reference ?? '';

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
        .getAddress(widget.zipController.text);
  }

  void clearFields({required bool clearZip}) {
    if (clearZip) {
      widget.zipController.clear();
    }
    widget.addressController.clear();
    widget.districtController.clear();
    widget.cityController.clear();
    state = null;
    widget.numberController.clear();
    widget.referenceController.clear();
    widget.complementController.clear();

    setState(() {
      showAllFields = false;
    });
  }

  void addAddress() {
    if (formKey.currentState?.validate() != true || widget.customer == null) {
      return;
    }

    if (widget.customer!.Addresses?.any(
          (e) =>
              e.Zip == widget.zipController.text &&
              e.Number == widget.numberController.text,
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
          widget.customer!.copyWith(
            Addresses: [
              ...?widget.customer!.Addresses,
              AddressEntity(
                Zip: widget.zipController.text,
                Address: widget.addressController.text,
                Number: widget.numberController.text,
                District: widget.districtController.text,
                City: widget.cityController.text,
                State: state,
                Complement: widget.complementController.text,
                Reference: widget.referenceController.text,
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
        widget.addressController.text = n.value?.Address ?? '';
        widget.districtController.text = n.value?.District ?? '';
        widget.cityController.text = n.value?.City ?? '';

        final stateIndex = BrazilStates.values.indexWhere(
          (e) => e.name == n.value?.State?.name,
        );

        if (stateIndex == -1) {
          return;
        } else {
          state = BrazilStates.values[stateIndex];
        }
        Future.delayed(Duration(milliseconds: 100), () {
          widget.numberFocusNode.requestFocus();
        });
      });
    });

    final getAddressAsync = ref.watch(getAddressByCepControllerProvider);

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
                      page: widget,
                      isLoading: getAddressAsync.isLoading,
                      seekAddress: seekAddress,
                      changeShowAllFields: (value) =>
                          setState(() => showAllFields = value),
                    ),
                  ),
                  if (showAllFields) ...[
                    gapH8,
                    AddressField(widget),
                    gapH8,
                    Row(
                      children: [
                        Expanded(child: DistrictField(widget)),
                        gapW8,
                        Expanded(child: CityField(widget)),
                      ],
                    ),
                    gapH8,
                    Row(
                      children: [
                        Expanded(
                          flex: 60,
                          child: StatesDropDown(
                            isLoading: getAddressAsync.isLoading,
                            onChangeState: (state) =>
                                setState(() => this.state = state),
                            state: state,
                          ),
                        ),
                        gapW8,
                        Expanded(
                          flex: 40,
                          child: NumberField(
                            isLoading: getAddressAsync.isLoading,
                            page: widget,
                          ),
                        ),
                      ],
                    ),
                    gapH8,
                    Row(
                      children: [
                        Expanded(
                          child: ComplementField(
                            isLoading: getAddressAsync.isLoading,
                            page: widget,
                          ),
                        ),
                        gapW8,
                        Expanded(
                          child: ReferenceField(
                            page: widget,
                            isLoading: getAddressAsync.isLoading,
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
              if (widget.customer?.Addresses != null &&
                  widget.customer!.Addresses!.isNotEmpty) ...[
                InformedAddressess(widget, widget.customer),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
