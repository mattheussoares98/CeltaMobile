import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import 'components/components.dart';

class EmailPage extends ConsumerWidget {
  const EmailPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text('E-mails'.hardcoded)),
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: Sizes.p4),
        child: ResponsiveScrollableWidget(
          isSliverPage: true,
          child: CustomScrollView(
            physics: ClampingScrollPhysics(),
            slivers: [EmailField(), InformedEmails()],
          ),
        ),
      ),
    );
  }
}
