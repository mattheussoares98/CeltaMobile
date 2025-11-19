import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:celta_intelligence/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../core/domain/entities/entities.dart';
import '../../../../../core/presentation/controllers/address/address.dart';
import '../../../../../core/presentation/widgets/address/address.dart';
import '../../controllers/controllers.dart';
import 'components/components.dart';

class AddressPage extends ConsumerStatefulWidget {
  const AddressPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddressPageState();
}

class _AddressPageState extends ConsumerState<AddressPage> {
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
          getAddressByCepControllerProvider(Modules.customerRegister).future,
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
        .read(
          getAddressByCepControllerProvider(Modules.customerRegister).notifier,
        )
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
    ref.invalidate(getAddressByCepControllerProvider(Modules.customerRegister));
    clearFields(clearZip: true);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(getAddressByCepControllerProvider(Modules.customerRegister), (
      p,
      n,
    ) {
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

    return Scaffold(
      appBar: AppBar(title: Text('Endereços'.hardcoded)),
      body: Form(
        key: formKey,
        child: const ResponsiveScrollableWidget(
          child: Column(
            children: [
              AddressForm(module: Modules.customerRegister),
              InformedAddressess(),
            ],
          ),
        ),
      ),
    );
  }
}
