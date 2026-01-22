import 'package:flutter/widgets.dart';

class EnterpriseUIController {
  final TextEditingController controller;
  final FocusNode focusNode;
  final int enterpriseCode;
  final String enterprisePersonalizedCode;

  EnterpriseUIController(
    this.controller,
    this.focusNode,
    this.enterpriseCode,
    this.enterprisePersonalizedCode,
  );
}
