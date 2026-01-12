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
  final dddFormKey = GlobalKey<FormState>();
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
    if (phoneFormKey.currentState?.validate() != true) {
      return;
    } else if (customer?.Telephones?.any(
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

    ref
        .read(customerStateControllerProvider.notifier)
        .updateCustomer(
          customer!.copyWith(
            Telephones: (customer.Telephones ?? [])
              ..add(
                CustomerTelephoneEntity(
                  AreaCode: dddController.text,
                  PhoneNumber: phoneController.text,
                ),
              ),
          ),
        );
    phoneController.clear();
    dddController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final customer = ref.watch(customerStateControllerProvider).value;

    return Scaffold(
      appBar: AppBar(title: Text('Telefones'.hardcoded)),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Sizes.p4),
        child: ResponsiveScrollableWidget(
          isSliverPage: true,
          child: Form(
            key: phoneFormKey,
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Form(
                              key: dddFormKey,
                              child: DddField(
                                dddController: dddController,
                                dddFormKey: dddFormKey,
                                phoneFocusNode: phoneFocusNode,
                              ),
                            ),
                          ),
                          gapW8,
                          Expanded(
                            flex: 3,
                            child: PhoneField(
                              customer: customer,
                              formKey: phoneFormKey,
                              dddController: dddController,
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
                if (customer?.Telephones != null &&
                    customer!.Telephones!.isNotEmpty) ...[
                  const InformedPhones(),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
