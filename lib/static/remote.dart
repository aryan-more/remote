import 'package:flutter/material.dart';
import 'package:remote/static/type.dart';

class Remote {
  static RemoteErrorLogger? _logger;

  static set logger(RemoteErrorLogger log) => _logger = log;

  static void logError(dynamic e, StackTrace s) {
    if (_logger != null) {
      _logger!(e, s);
    }
  }

  static late final Future<void> Function() logOut;

  static late final Future<T> Function<T>(Task task) showLoading;

  static late final void Function({required String message, required String? confirmText, required VoidCallback callback, bool dismissible}) showError;

  static late final Future<String?> Function() renewToken;

  static void init({
    required Future<void> Function() logOutFunc,
    required Future<T> Function<T>(Task task) showLoadingFunc,
    required void Function({required String message, required String? confirmText, required VoidCallback callback, bool dismissible}) showErrorFunc,
    required Future<String?> Function() renewTokenFunc,
  }) {
    logOut = logOutFunc;
    showLoading = showLoadingFunc;
    showError = showErrorFunc;
    renewToken = renewTokenFunc;
  }
}

typedef RemoteErrorLogger = Function(dynamic e, StackTrace s);
