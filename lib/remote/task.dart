import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remote/error_handler/error.dart';
import 'package:remote/error_handler/http.dart';
import 'package:remote/remote/dialog.dart';
import 'package:remote/remote/token.dart';

abstract class LocalTask extends GetxController {
  void onDone() {}

  void runTask();
}

abstract class RemoteTask extends LocalTask with ExpiredTokenMixIn, RemoteTaskDialog {
  Future<void> task();
  Future<bool> validate() async {
    return true;
  }

  @override
  Future<bool> runTask({bool retry = true}) async {
    String? error;
    try {
      if (!(await validate())) {
        return false;
      }
      await loading(() => httpErrorHandler(task()));
    } on AppException catch (e, s) {
      error = e.msg;
      log(s.toString());
    } on ExpiredToken catch (_) {
      if (retry) {
        error = await loading(
          () => renewToken(),
        );
        if (error == null) {
          return runTask(retry: false);
        }
      }
      error = 'Failed to authenticate user';
    } catch (e, s) {
      log(e.toString());
      log(s.toString());

      error = "Something went wrong";
    }

    if (error != null) {
      showError(message: error, confirmText: "Retry", callback: runTask);
      return false;
    } else {
      onDone();
      return true;
    }
  }
}

mixin RemoteTaskForm on RemoteTask {
  final GlobalKey<FormState> formKey = GlobalKey();

  @override
  Future<bool> validate() async {
    return formKey.currentState!.validate();
  }
}
