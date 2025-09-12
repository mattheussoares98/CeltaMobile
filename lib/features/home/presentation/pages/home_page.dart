import 'package:celta_intelligence/features/auth/presentation/controllers/controllers.dart';
import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:celta_intelligence/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../commom_widgets/commom_widgets.dart';
import '../../../../routing/routing.dart';
import 'components/components.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(authStateControllerProvider, (previous, next) {
      next.showAlertDialogOnError(context);
      if (next.value == null) {
        context.goNamed(AppRoute.auth.name);
      }
    });
    return Scaffold(
      appBar: AppBar(),
      drawer: CompleteDrawer(),
      body: ResponsiveScrollableWidget(
        child: Column(children: [Text('Home'.hardcoded)]),
      ),
    );
  }
}
