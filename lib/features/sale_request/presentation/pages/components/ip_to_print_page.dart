import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/core/validators/validators.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class IpToPrintPage extends ConsumerStatefulWidget {
  final int enterpriseCode;
  final int? saleRequestId;
  final int? customerCode;
  const IpToPrintPage({
    super.key,
    required this.enterpriseCode,
    this.saleRequestId,
    this.customerCode,
  });

  @override
  ConsumerState<IpToPrintPage> createState() => _IpToPrintPageState();
}

class _IpToPrintPageState extends ConsumerState<IpToPrintPage> {
  final ipController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    ipController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        final ip = await ref.read(ipPrintSaleRequestControllerProvider.future);

        ipController.text = ip ?? '';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: false,
        body: _IpToPrintForm(
          formKey: formKey,
          ipController: ipController,
          enterpriseCode: widget.enterpriseCode,
          saleRequestId: widget.saleRequestId,
          customerCode: widget.customerCode,
        ),
      ),
    );
  }
}

class _IpToPrintForm extends ConsumerWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController ipController;
  final int enterpriseCode;
  final int? saleRequestId;
  final int? customerCode;

  const _IpToPrintForm({
    required this.formKey,
    required this.ipController,
    required this.enterpriseCode,
    this.saleRequestId,
    this.customerCode,
  });

  void _print(WidgetRef ref) async {
    if (formKey.currentState?.validate() != true) {
      return;
    }

    if (customerCode != null && saleRequestId != null) {
      await ref
          .read(printSaleRequestControllerProvider.notifier)
          .bsfPrint(
            saleRequestCode: saleRequestId!,
            customerCode: customerCode!,
            enterpriseCode: enterpriseCode,
            ip: ipController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(printSaleRequestControllerProvider, (p, n) {
      n.showSnackbarOnError(context, p);
    });

    final isLoading = ref.watch(
      printSaleRequestControllerProvider.select((s) => s.isLoading),
    );

    return SizedBox(
      width: 320,
      child: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              BaseTextFormField(
                labelText: 'IP da impressora'.hardcoded,
                hintText: '192.168.0.1',
                maxLength: 15,
                controller: ipController,
                enabled: !isLoading,
                onFieldSubmitted: (_) => _print(ref),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[\d.]')),
                ],
                validator: FormValidators.compose([
                  NonEmptyValidator(),
                  IpValidator(),
                ]),
                keyboardType: TextInputType.datetime,
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: PrimaryTextButton(
                      text: 'Cancelar'.hardcoded,
                      onPressed: context.pop,
                      color: Colors.red,
                    ),
                  ),
                  Flexible(
                    child: PrimaryButton(
                      text: 'Imprimir'.hardcoded,
                      isLoading: isLoading,
                      onPressed: () => _print(ref),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
