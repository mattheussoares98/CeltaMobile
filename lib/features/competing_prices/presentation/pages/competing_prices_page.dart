import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../localization/string_hardcoded.dart';

class CompetingPricesPage extends ConsumerWidget {
  const CompetingPricesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text('Preços concorrentes'.hardcoded)),
    );
  }
}
