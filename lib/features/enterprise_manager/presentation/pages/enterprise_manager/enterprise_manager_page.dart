import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../routing/routing.dart';
import '../../controllers/controllers.dart';
import 'components/components.dart';

class EnterpriseManagerPage extends ConsumerStatefulWidget {
  const EnterpriseManagerPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EnterpriseManagerPageState();
}

class _EnterpriseManagerPageState extends ConsumerState<EnterpriseManagerPage> {
  final enterpriseNameController = TextEditingController();
  final urlController = TextEditingController();
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  final filterEnterpriseNameController = TextEditingController();
  final urlFocusNode = FocusNode();
  final userNameFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();

  @override
  void dispose() {
    super.dispose();

    enterpriseNameController.dispose();
    urlController.dispose();
    userNameController.dispose();
    passwordController.dispose();
    filterEnterpriseNameController.dispose();
    urlFocusNode.dispose();
    userNameFocusNode.dispose();
    passwordFocusNode.dispose();
  }

  Future<void> onSubmit() async {
    await ref
        .read(createEnterpriseControllerProvider.notifier)
        .createEnterprise(
          urlInUse: urlController.text,
          enterpriseName: enterpriseNameController.text,
          password: passwordController.text,
          userName: userNameController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Gerenciar módulos'.hardcoded),
        actions: const [LogoutButton()],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.pushNamed(Routes.createEnterprise.name);
        },
        child: Icon(
          theme.platform == TargetPlatform.iOS ? CupertinoIcons.add : Icons.add,
        ),
      ),
      body: AsyncValueWidget(
        value: ref.watch(enterpriseManagerControllerProvider),
        tryAgain: () => ref.invalidate(enterpriseManagerControllerProvider),
        data: (enterprises) {
          if (enterprises.isEmpty) {
            return Center(child: Text('Nenhuma empresa encontrada.'.hardcoded));
          }
          return EnterpriseItems(
            enterprises: enterprises,
            filterEnterpriseNameController: filterEnterpriseNameController,
          );
        },
      ),
    );
  }
}
