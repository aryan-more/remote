import 'dart:async';
import 'dart:developer';

import 'package:remote/error_handler/error.dart';

Future<T?> httpErrorHandler<T>(Future<T?> task) async {
  try {
    return await task;
  } on AppException catch (_) {
    rethrow;
  } on ExpiredToken catch (_) {
    rethrow;
  } catch (_, s) {
    log(s.toString());
    log(_.toString());
    throw AppException("Network Error");
  }
}
