import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../localization/string_hardcoded.dart';

class CompetingPricesResearchs extends ConsumerWidget {
  final int enterpriseCode;
  const CompetingPricesResearchs({super.key, required this.enterpriseCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text('Preços concorrentes'.hardcoded)),
    );
  }
}
