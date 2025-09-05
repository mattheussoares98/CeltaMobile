import 'package:flutter/material.dart';

class CeltaImage extends StatelessWidget {
  const CeltaImage({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: Image.asset("lib/core/assets/images/logoCeltaTransparente.png"),
    );
  }
}
