import 'dart:developer';

import 'package:remote/error_handler/error.dart';

T parseJsonError<T>(T Function() func) {
  try {
    return func();
  } catch (_, s) {
    log(s.toString());
    throw AppException("Failed to parse response");
  }
}
