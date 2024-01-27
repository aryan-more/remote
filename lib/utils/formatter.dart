import 'package:flutter/services.dart';

final doubleFormatter = [
  FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
  TextInputFormatter.withFunction(
    (oldValue, newValue) {
      if (newValue.text.isEmpty) {
        return newValue;
      }
      if (double.tryParse(newValue.text) != null) {
        return newValue;
      }
      return oldValue;
    },
  ),
];
