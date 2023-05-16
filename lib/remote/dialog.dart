import 'dart:async';

import 'package:flutter/material.dart';
import 'package:remote/error_handler/error.dart';

mixin RemoteTaskDialog {
  Future<T> loading<T>(FutureOr<T?> Function() task) async {
    throw AppException('Please implemente RemoteTaskDialog mixin');
  }

  void showError({
    required String message,
    required String? confirmText,
    required VoidCallback callback,
    bool dismissible = true,
  }) {}
}
