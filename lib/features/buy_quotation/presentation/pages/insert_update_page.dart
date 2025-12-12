import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';

class InsertUpdatePage extends StatelessWidget {
  final int? code;
  final int enterpriseCode;
  const InsertUpdatePage({
    super.key,
    required this.code,
    required this.enterpriseCode,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          code == null ? 'Inseririndo'.hardcoded : 'Alterarando'.hardcoded,
        ),
      ),
    );
  }
}
