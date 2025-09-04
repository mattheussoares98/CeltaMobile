import '../commom_widgets/commom_widgets.dart';
import '/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: EmptyPlaceholderWidget(
        message: '404 - Página não encontrada!'.hardcoded,
      ),
    );
  }
}
