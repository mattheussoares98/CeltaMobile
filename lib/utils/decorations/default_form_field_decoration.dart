import 'package:flutter/material.dart';

class DefaultFormFieldDecoration extends InputDecoration {
  DefaultFormFieldDecoration(
    BuildContext context, {
    super.labelText,
    super.prefixIcon,
    super.suffixIcon,
    super.errorText,
    super.hintText,
    bool showCounterText = false,
    double? fontSize,
  }) : super(
          counterText: showCounterText == false ? "" : null,
          suffixIconColor: Theme.of(context).colorScheme.primary,
          prefixIconColor: Theme.of(context).colorScheme.primary,
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              style: BorderStyle.solid,
              width: 1,
              color: Color.fromARGB(255, 171, 35, 35),
            ),
          ),
          hintStyle: TextStyle(
            color: Colors.grey,
            fontSize:
                fontSize ?? Theme.of(context).textTheme.bodyLarge?.fontSize,
          ),
          labelStyle: TextStyle(
            color: Colors.black,
            fontStyle: FontStyle.italic,
            fontSize:
                fontSize ?? Theme.of(context).textTheme.bodyLarge?.fontSize,
          ),
          floatingLabelStyle: TextStyle(
            color: Colors.black,
            fontSize:
                fontSize ?? Theme.of(context).textTheme.bodyLarge?.fontSize,
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              style: BorderStyle.solid,
              width: 1,
              color: Colors.grey,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              style: BorderStyle.solid,
              width: 1,
              color: Colors.grey,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              style: BorderStyle.solid,
              width: 1,
              color: Color.fromARGB(255, 171, 35, 35),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              style: BorderStyle.solid,
              width: 1,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              style: BorderStyle.solid,
              width: 1,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        );
}
