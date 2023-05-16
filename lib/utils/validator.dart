import 'package:flutter/material.dart';

String? emptyValidator(String? text, String field) {
  if (text == null || text.isEmpty) {
    debugPrint("$field cannot be empty");
    return "$field cannot be empty";
  }
  return null;
}

String? minLengthValidator(String? text, String field, int minLength) {
  return emptyValidator(text, field) ??
      () {
        if (text!.length < minLength) {
          return "$field should be $minLength characters log";
        }
      }();
}
