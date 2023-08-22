import 'dart:async';
import 'dart:developer';

import 'package:remote/remote.dart';

Future<T?> httpErrorHandler<T>(Future<T?> task) async {
  try {
    return await task;
  } on AppException catch (_) {
    rethrow;
  } on ExpiredToken catch (_) {
    rethrow;
  } catch (_, s) {
    Remote.logError(_, s);
    log(s.toString());
    log(_.toString());
    throw AppException("Something went wrong");
  }
}
