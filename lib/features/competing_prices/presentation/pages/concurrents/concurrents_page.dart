import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../localization/string_hardcoded.dart';

class ConcurrentsPage extends ConsumerWidget {
  final int researchCode;
  const ConcurrentsPage({super.key, required this.researchCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(body: Center(child: Text('Concorrentes'.hardcoded)));
  }
}
