import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/customer_register/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/customer_register/presentation/pages/phone/components/components.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PhonePage extends ConsumerStatefulWidget {
  const PhonePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PhonePageState();
}

class _PhonePageState extends ConsumerState<PhonePage> {
  final phoneFormKey = GlobalKey<FormState>();
  final dddController = TextEditingController();
  final phoneController = TextEditingController();
  final phoneFocusNode = FocusNode();
  final dddFocusNode = FocusNode();

  @override
  void dispose() {
    super.dispose();

    dddController.dispose();
    phoneController.dispose();
    phoneFocusNode.dispose();
    dddFocusNode.dispose();
  }

  void addPhone() async {
    final customer = await ref.read(customerStateControllerProvider.future);
    final telephones = customer?.Telephones;
    if (phoneFormKey.currentState?.validate() != true) {
      return;
    }

    if (telephones?.any(
          (e) =>
              e.PhoneNumber == phoneController.text &&
              e.AreaCode == dddController.text,
        ) ??
        false) {
      if (!mounted) return;
      showToastMessage(
        'Esse telefone já foi adicionado'.hardcoded,
        type: ToastType.error,
      );
      return;
    }

    ref.read(customerStateControllerProvider.notifier).updateTelephones([
      ...?telephones,
      CustomerTelephoneEntity(
        AreaCode: dddController.text,
        PhoneNumber: phoneController.text,
      ),
    ]);
    phoneController.clear();
    dddController.clear();
    phoneFocusNode.unfocus();

    phoneFormKey.currentState?.reset();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScrollableWidget(
      isSliverPage: true,
      child: Form(
        key: phoneFormKey,
        child: Column(
          children: [
            Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: DddField(
                        dddController: dddController,
                        phoneFocusNode: phoneFocusNode,
                        dddFocusNode: dddFocusNode,
                      ),
                    ),
                    gapW8,
                    Expanded(
                      flex: 3,
                      child: PhoneField(
                        phoneController: phoneController,
                        phoneFocusNode: phoneFocusNode,
                        addPhone: addPhone,
                      ),
                    ),
                  ],
                ),
                gapH32,
                PrimaryButton(
                  text: 'Adicionar telefone'.hardcoded,
                  onPressed: addPhone,
                ),
              ],
            ),
            const Expanded(
              child: CustomScrollView(
                physics: ClampingScrollPhysics(),
                slivers: [InformedPhones()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
