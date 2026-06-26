import 'package:flutter/material.dart';

import 'text.dart';

class DefaultText extends StatelessWidget {
  const DefaultText(
    this.text, {
    super.key,
    this.textAlign,
    this.overflow,
    this.maxLines,
    this.color,
    this.textType = TextType.bodyMedium,
    this.fontWeight = FontWeight.normal,
    this.decoration,
    this.decorationColor,
    this.fontStyle,
  });

  factory DefaultText.caption(
    String text, {
    TextAlign? textAlign,
    TextOverflow? overflow,
    Color? color,
    FontWeight? fontWeight,
    TextDecoration? decoration,
    Color? decorationColor,
    FontStyle? fontStyle,
    int? maxLines,
  }) => DefaultText(
    text,
    textAlign: textAlign,
    maxLines: maxLines,
    overflow: overflow,
    color: color,
    textType: TextType.caption,
    fontWeight: fontWeight ?? FontWeight.w400,
    decoration: decoration,
    decorationColor: decorationColor,
    fontStyle: fontStyle,
  );

  factory DefaultText.bodySmall(
    String text, {
    TextAlign? textAlign,
    TextOverflow? overflow,
    int? maxLines,
    Color? color,
    FontWeight? fontWeight,
    TextDecoration? decoration,
    Color? decorationColor,
    FontStyle? fontStyle,
  }) => DefaultText(
    text,
    textAlign: textAlign,
    overflow: overflow,
    maxLines: maxLines,
    color: color,
    textType: TextType.bodySmall,
    fontWeight: fontWeight ?? FontWeight.w400,
    decoration: decoration,
    decorationColor: decorationColor,
    fontStyle: fontStyle,
  );

  factory DefaultText.bodyLarge(
    String text, {
    TextAlign? textAlign,
    Color? color,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
  }) => DefaultText(
    text,
    textAlign: textAlign,
    color: color,
    textType: TextType.bodyLarge,
    fontWeight: fontWeight ?? FontWeight.w400,
    fontStyle: fontStyle,
  );

  factory DefaultText.title(
    String text, {
    TextAlign? textAlign,
    Color? color,
    FontStyle? fontStyle,
  }) => DefaultText(
    text,
    textAlign: textAlign,
    color: color,
    textType: TextType.titleSmall,
    fontWeight: FontWeight.w600,
    fontStyle: fontStyle,
  );

  factory DefaultText.titleMedium(
    String text, {
    TextAlign? textAlign,
    Color? color,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
  }) => DefaultText(
    text,
    textAlign: textAlign,
    color: color,
    textType: TextType.titleMedium,
    fontWeight: fontWeight ?? FontWeight.w600,
    fontStyle: fontStyle,
  );
  factory DefaultText.titleLarge(
    String text, {
    TextAlign? textAlign,
    Color? color,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
  }) => DefaultText(
    text,
    textAlign: textAlign,
    color: color,
    textType: TextType.titleLarge,
    fontWeight: fontWeight ?? FontWeight.bold,
    fontStyle: fontStyle,
  );

  factory DefaultText.bodyMedium(
    String text, {
    TextAlign? textAlign,
    TextOverflow? overflow,
    Color? color,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
  }) => DefaultText(
    text,
    textAlign: textAlign,
    overflow: overflow,
    color: color,
    fontWeight: fontWeight ?? FontWeight.w400,
    fontStyle: fontStyle,
  );

  factory DefaultText.headline(
    String text, {
    Color? color,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
  }) => DefaultText(
    text,
    color: color,
    textType: TextType.headline,
    fontWeight: fontWeight ?? FontWeight.w600,
    fontStyle: fontStyle,
  );

  factory DefaultText.headlineLarge(
    String text, {
    Color? color,
    FontStyle? fontStyle,
  }) => DefaultText(
    text,
    color: color,
    textType: TextType.headlineLarge,
    fontWeight: FontWeight.w600,
    fontStyle: fontStyle,
  );
  factory DefaultText.error(
    String text, {
    TextAlign? textAlign,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
  }) => DefaultText(
    text,
    textAlign: textAlign ?? TextAlign.center,
    color: Colors.red,
    textType: TextType.titleMedium,
    fontWeight: fontWeight ?? FontWeight.w600,
    fontStyle: fontStyle,
  );

  final String text;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;
  final Color? color;
  final TextType textType;
  final FontWeight fontWeight;
  final TextDecoration? decoration;
  final Color? decorationColor;
  final FontStyle? fontStyle;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      overflow: overflow,
      style: TextStyle(
        color: color,
        fontSize: textType.size,
        fontWeight: fontWeight,
        decoration: decoration,
        decorationColor: decorationColor,
        fontStyle: fontStyle,
      ),
    );
  }
}
