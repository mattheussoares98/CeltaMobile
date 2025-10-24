import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransferRequestsTypesPage extends ConsumerWidget {
  const TransferRequestsTypesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(appBar: AppBar(title: Text('Modelos de pedido'.hardcoded)));
  }
}
