import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remote/error_handler/error.dart';
import 'package:remote/error_handler/http.dart';
import 'package:remote/remote/dialog.dart';
import 'package:remote/remote/logout.dart';
import 'package:remote/remote/token.dart';
import 'package:remote/static/remote.dart';

abstract class LocalTask extends GetxController {
  void onDone() {}

  void runTask();
}

abstract class RemoteTask extends LocalTask with ExpiredTokenMixIn, RemoteTaskDialog, LogOutMixin {
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
        try {
          error = await loading(
            () => renewToken(),
          );
          if (error == null) {
            return runTask(retry: false);
          }
        } on LogOutUser catch (_) {
          Get.back();
          await logOut();
          return false;
        } catch (_) {
          error = "Something went wrong";
        }
      }
      error = 'Failed to authenticate user';
    } catch (e, s) {
      Remote.logError(e, s);
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
