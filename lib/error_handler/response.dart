import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:remote/error_handler/error.dart';

Future<T> responseError<T>(http.Response response) => compute(bodyError, response.body);

T bodyError<T>(String body) {
  T data;
  try {
    data = jsonDecode(body);
  } catch (_) {
    log(body);
    throw AppException("Failed to parse body");
  }

  if (data is Map && ((data.containsKey('error') && data['error'] is bool && data['error'] as bool) || (data.containsKey('status') && !(data['status'] as bool)))) {
    if ("Token Time Expire." == data['message']) {
      throw ExpiredToken();
    }

    throw AppException(data['message'] ?? "Something went wrong");
  }

  return data;
}
