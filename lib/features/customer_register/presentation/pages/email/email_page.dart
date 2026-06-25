import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/features/customer_register/presentation/pages/email/components/components.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EmailPage extends ConsumerWidget {
  const EmailPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BaseScaffold(
      isScrollable: false,
      usePadding: true,
      appBar: DefaultAppBar(
        title: 'E-mails'.hardcoded,
        showSelectedEnterprise: false,
      ),
      body: const ResponsiveScrollableWidget(
        isSliverPage: true,
        child: Column(
          children: [
            EmailField(),
            Expanded(
              child: CustomScrollView(
                physics: ClampingScrollPhysics(),
                slivers: [InformedEmails()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
