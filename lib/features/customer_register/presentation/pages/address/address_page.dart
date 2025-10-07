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
  final BrazilStates? state;
  final FocusNode numberFocusNode;
  final FocusNode complementFocusNode;
  final FocusNode referenceFocusNode;
  final FocusNode zipFocusNode;
  final void Function(BrazilStates? state) onChangeState;
  final List<AddressEntity> addressess;
  final VoidCallback addAddress;
  final GlobalKey<FormState> formKey;
  final void Function(int index) removeAddress;
  final bool showAddressFields;
  final void Function(bool value) changeShowAllFields;

  const AddressPage({
    super.key,
    required this.zipController,
    required this.numberController,
    required this.addressController,
    required this.districtController,
    required this.cityController,
    required this.complementController,
    required this.referenceController,
    required this.state,
    required this.numberFocusNode,
    required this.complementFocusNode,
    required this.referenceFocusNode,
    required this.zipFocusNode,
    required this.onChangeState,
    required this.addressess,
    required this.addAddress,
    required this.formKey,
    required this.removeAddress,
    required this.showAddressFields,
    required this.changeShowAllFields,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddressPageState();
}

class _AddressPageState extends ConsumerState<AddressPage> {
  final zipFormKey = GlobalKey<FormState>();
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
    widget.onChangeState(null);
    widget.numberController.clear();
    widget.referenceController.clear();
    widget.complementController.clear();
  }

  void addAddress() {
    if (widget.formKey.currentState?.validate() != true) {
      return;
    }

    if (widget.addressess.any(
      (e) =>
          e.Zip == widget.zipController.text &&
          e.Number == widget.numberController.text,
    )) {
      showSnackBarMessage(
        context,
        'Esse endereço já foi inserido'.hardcoded,
        backgroundColor: Colors.red,
      );
      return;
    }
    widget.addAddress();
    ref.invalidate(getAddressByCepControllerProvider);
    widget.changeShowAllFields(false);
    clearFields(clearZip: true);
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
          widget.changeShowAllFields(true);
          widget.addressController.text = address.Address;
          widget.districtController.text = address.District;
          widget.cityController.text = address.City;
          widget.complementController.text = address.Complement ?? '';
          widget.referenceController.text = address.Reference ?? '';

          final stateIndex = BrazilStates.values.indexWhere(
            (e) => e.name == address.State,
          );
          if (stateIndex == -1) {
            return;
          } else {
            widget.onChangeState(BrazilStates.values[stateIndex]);
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(getAddressByCepControllerProvider, (p, n) {
      if (n.hasError) {
        clearFields(clearZip: false);
        widget.changeShowAllFields(false);
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
        widget.changeShowAllFields(true);
        widget.addressController.text = n.value?.Address ?? '';
        widget.districtController.text = n.value?.District ?? '';
        widget.cityController.text = n.value?.City ?? '';

        final stateIndex = BrazilStates.values.indexWhere(
          (e) => e.name == n.value?.State,
        );

        if (stateIndex == -1) {
          return;
        } else {
          widget.onChangeState(BrazilStates.values[stateIndex]);
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
        key: widget.formKey,
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
                    ),
                  ),
                  if (widget.showAddressFields) ...[
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
                            page: widget,
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
              if (widget.addressess.isNotEmpty) ...[InformedAddressess(widget)],
            ],
          ),
        ),
      ),
    );
  }
}
