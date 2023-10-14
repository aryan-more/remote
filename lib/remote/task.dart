import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mutex/mutex.dart';
import 'package:remote/error_handler/error.dart';
import 'package:remote/static/remote.dart';

abstract class LocalTask extends GetxController {
  void onDone() {}

  void runTask();
}

abstract class RemoteTask extends LocalTask {
  final Mutex _mutex = Mutex();
  Future<void> task();
  Future<bool> validate() async {
    return true;
  }

  @override
  Future<bool> runTask({bool retry = true}) async {
    if (_mutex.isLocked) {
      return false;
    }
    await _mutex.acquire();
    String? error;
    try {
      if (!(await validate())) {
        return false;
      }
      await Remote.showLoading(() => task());
    } on AppException catch (e, s) {
      error = e.msg;
      log(s.toString());
    } on ExpiredToken catch (_) {
      if (retry) {
        try {
          error = await Remote.showLoading(
            () => Remote.renewToken(),
          );
          if (error == null) {
            return runTask(retry: false);
          }
        } on LogOutUser catch (_) {
          Get.back();
          await Remote.logOut();
          return false;
        } catch (_) {
          error = "Something went wrong";
        }
      }
      error = 'Failed to authenticate user';
    } catch (e, s) {
      if (Remote.customErrorHandler.containsKey(e.runtimeType)) {
        error = Remote.customErrorHandler[e.runtimeType]!(e);
      } else {
        Remote.logError(e, s);
        log(e.toString());
        log(s.toString());
        error = "Something went wrong";
      }
    }

    if (error != null) {
      Remote.showError(message: error, confirmText: "Retry", callback: runTask);
      _mutex.release();
      return false;
    } else {
      onDone();
      _mutex.release();
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
