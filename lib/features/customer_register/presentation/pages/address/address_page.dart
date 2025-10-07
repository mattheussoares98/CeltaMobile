import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:celta_intelligence/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../../../../core/domain/entities/entities.dart';
import '../../../../../core/validators/validators.dart';
import '../../controllers/controllers.dart';

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
  final void Function(BrazilStates? state) onChangeState;
  final List<AddressEntity> addressess;
  final VoidCallback addAddress;
  final GlobalKey<FormState> formKey;
  final void Function(int index) removeAddress;

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
    required this.onChangeState,
    required this.addressess,
    required this.addAddress,
    required this.formKey,
    required this.removeAddress,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddressPageState();
}

class _AddressPageState extends ConsumerState<AddressPage> {
  bool showAllFIelds = false;

  @override
  Widget build(BuildContext context) {
    Future<void> seekAddress() async {
      ref
          .read(getAddressByCepControllerProvider.notifier)
          .getAddress(widget.zipController.text);
    }
    //TODO create separeted files

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

    ref.listen(getAddressByCepControllerProvider, (p, n) {
      if (n.hasError) {
        clearFields(clearZip: false);
      }
      n.showSnackbarOnError(
        context,
        previous: p,
        message: 'Ocorreu um erro não esperado. Tente novamente'.hardcoded,
      );
      //TODO test this error. Probably needs to throw in the datasource
      n.doOnSuccess(p, () {
        if (n.value == null) {
          return;
        }
        setState(() {
          showAllFIelds = true;
        });
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

    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;

    return Scaffold(
      appBar: AppBar(title: Text('Endereços'.hardcoded)),
      body: Form(
        key: widget.formKey,
        child: ResponsiveScrollableWidget(
          child: Column(
            children: [
              Column(
                children: [
                  DefaultTextFormField(
                    controller: widget.zipController,
                    enabled: !getAddressAsync.isLoading,
                    maxLength: 8,
                    labelText: 'CEP'.hardcoded,
                    hintText: 'CEP'.hardcoded,
                    suffixIcon: getAddressAsync.isLoading
                        ? LoadingWidget(size: Sizes.p16)
                        : IconButton(
                            onPressed: () {
                              widget.zipController.clear();
                              setState(() {
                                showAllFIelds = false;
                              });
                            },
                            icon: Icon(
                              isIOS ? CupertinoIcons.delete : Icons.delete,
                              color: Colors.red,
                            ),
                          ),
                    onChanged: (value) {
                      if (value.length == 8) {
                        seekAddress();
                      }
                    },
                    keyboardType: TextInputType.numberWithOptions(
                      decimal: false,
                    ), //TODO test in iOS
                    onFieldSubmitted: (_) {
                      seekAddress();
                    },
                    validator: FormValidators.compose([
                      NonEmptyValidator(),
                      NumberValidator(allowDecimal: false),
                      MinLengthValidator(8),
                    ]),
                  ),
                  if (showAllFIelds) ...[
                    gapH8,
                    DefaultTextFormField(
                      controller: widget.addressController,
                      enabled: false,
                      labelText: 'Logradouro'.hardcoded,
                      hintText: 'Logradouro'.hardcoded,
                    ),
                    gapH8,
                    Row(
                      children: [
                        Expanded(
                          child: DefaultTextFormField(
                            controller: widget.districtController,
                            enabled: false,
                            labelText: 'Bairro'.hardcoded,
                            hintText: 'Bairro'.hardcoded,
                          ),
                        ),
                        gapW8,
                        Expanded(
                          child: DefaultTextFormField(
                            controller: widget.cityController,
                            enabled: false,
                            labelText: 'Cidade'.hardcoded,
                            hintText: 'Cidade'.hardcoded,
                          ),
                        ),
                      ],
                    ),
                    gapH8,
                    Row(
                      children: [
                        Expanded(
                          flex: 60,
                          child: DefaultSimpleDropDown<BrazilStates?>(
                            isLoading: getAddressAsync.isLoading,
                            onChanged: null,
                            items: BrazilStates.values
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    onTap: () => widget.onChangeState(e),
                                    child: Center(child: Text(e.name)),
                                  ),
                                )
                                .toList(),
                            value: widget.state,
                            hint: 'Estado'.hardcoded,
                          ),
                        ),
                        gapW8,
                        Expanded(
                          flex: 40,
                          child: DefaultTextFormField(
                            enabled: !getAddressAsync.isLoading,
                            controller: widget.numberController,
                            focusNode: widget.numberFocusNode,
                            labelText: 'Número'.hardcoded,
                            hintText: 'Número'.hardcoded,
                            validator: FormValidators.compose([
                              NonEmptyValidator(),
                              MinLengthValidator(1),
                              NumberValidator(allowDecimal: false),
                            ]),
                            onFieldSubmitted: (_) {
                              widget.complementFocusNode.requestFocus();
                            },
                            keyboardType: TextInputType.numberWithOptions(
                              decimal: false,
                            ), //TODO test in iOS
                          ),
                        ),
                      ],
                    ),
                    gapH8,
                    Row(
                      children: [
                        Expanded(
                          child: DefaultTextFormField(
                            enabled: !getAddressAsync.isLoading,
                            controller: widget.complementController,
                            focusNode: widget.complementFocusNode,
                            labelText: 'Complemento'.hardcoded,
                            hintText: 'Complemento'.hardcoded,
                            onFieldSubmitted: (_) {
                              widget.referenceFocusNode.requestFocus();
                            },
                          ),
                        ),
                        gapW8,
                        Expanded(
                          child: DefaultTextFormField(
                            focusNode: widget.referenceFocusNode,
                            enabled: !getAddressAsync.isLoading,
                            controller: widget.referenceController,
                            labelText: 'Referência'.hardcoded,
                            hintText: 'Referência'.hardcoded,
                          ),
                        ),
                      ],
                    ),
                    gapH32,
                    PrimaryButton(
                      text: 'Adicionar endereço'.hardcoded,
                      onPressed: () {
                        widget.addAddress();
                        //TODO move showAllFields and clearFields to previous page
                        setState(() {
                          showAllFIelds = false;
                        });
                        clearFields(clearZip: true);
                      },
                    ),
                  ],
                ],
              ),
              if (widget.addressess.isNotEmpty) ...[
                gapH16,
                Divider(thickness: 0.5),
                Text(
                  'Endereços informados'.hardcoded,
                  style: theme.textTheme.titleLarge,
                ),
                gapH8,
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.addressess.length,
                  itemBuilder: (_, index) {
                    final address = widget.addressess[index];
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(Sizes.p8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: TitleAndSubTitle(
                                    title: 'CEP '.hardcoded,
                                    subTitle: address.Zip,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    widget.removeAddress(index);
                                  },
                                  icon: Icon(
                                    isIOS
                                        ? CupertinoIcons.delete
                                        : Icons.delete,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              '${address.Address}, número ${address.Number}. ${address.District}, ${address.City}, ${address.State}',
                            ),
                            if (address.Complement != null &&
                                address.Complement!.isNotEmpty)
                              TitleAndSubTitle(
                                title: 'Complemento '.hardcoded,
                                subTitle: address.Complement,
                              ),
                            if (address.Reference != null &&
                                address.Reference!.isNotEmpty)
                              TitleAndSubTitle(
                                title: 'Referência '.hardcoded,
                                subTitle: address.Reference,
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
