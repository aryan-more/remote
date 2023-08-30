import 'dart:async';

import 'package:flutter/material.dart';

typedef Task<T> = FutureOr<T> Function();
typedef LogOut = Future<void> Function();
typedef ShowLoading = Future<T> Function<T>(Task<T> task);
typedef RenewToken = Future<String?> Function();
typedef ShowError = void Function({required String message, required String? confirmText, required VoidCallback callback, bool dismissible});
