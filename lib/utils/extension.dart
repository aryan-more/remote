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

  String get ago {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? 'year' : 'years'} ago';
    }

    if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    }

    if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    }

    if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    }

    if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    }
    return 'Just now';
  }
}

class EdgeInsetsEXT {
  static EdgeInsets allExceptTop(double padding) => EdgeInsets.only(
        bottom: padding,
        left: padding,
        right: padding,
      );
}
