import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../../../../core/domain/entities/entities.dart';
import '../../controllers/controllers.dart';
import 'components/components.dart';

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
    final telephones = await ref.read(
      customerStateControllerProvider.selectAsync((s) => s?.Telephones),
    );
    if (phoneFormKey.currentState?.validate() != true) {
      return;
    }

    if (telephones?.any(
          (e) =>
              e.PhoneNumber == phoneController.text &&
              e.AreaCode == dddController.text,
        ) ??
        false) {
      showSnackBarMessage(
        context,
        'Esse telefone já foi adicionado'.hardcoded,
        backgroundColor: Colors.red,
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
    return Scaffold(
      appBar: AppBar(title: Text('Telefones'.hardcoded)),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Sizes.p4),
        child: ResponsiveScrollableWidget(
          isSliverPage: true,
          child: Form(
            key: phoneFormKey,
            child: CustomScrollView(
              physics: const ClampingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: DddField(
                              dddController: dddController,
                              phoneFocusNode: phoneFocusNode,
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
                ),
                const InformedPhones(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
