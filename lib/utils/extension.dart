import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String _addZero(int number) {
  String converted = number.toString();
  if (converted.length == 1) {
    converted = "0$converted";
  }
  return converted;
}

extension DateTimeExt on DateTime {
  String get ymd => "$year-${_addZero(month)}-${_addZero(day)}";
  String get dmy => "${_addZero(day)}-${_addZero(month)}-$year";

  String get dateTime => DateFormat.yMMMd().add_jm().format(this);
}

class EdgeInsetsEXT {
  static EdgeInsets allExceptTop(double padding) => EdgeInsets.only(
        bottom: padding,
        left: padding,
        right: padding,
      );
}
