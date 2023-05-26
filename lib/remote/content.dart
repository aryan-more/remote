import 'dart:developer';

import 'package:get/get.dart';
import 'package:remote/error_handler/error.dart';
import 'package:remote/error_handler/http.dart';
import 'package:remote/remote/remote.dart';

abstract class RemoteContent extends GetxController with ExpiredTokenMixIn, LogOutMixin {
  bool loading = false;
  String? error;
  final bool defaultLoad;
  final bool updateController;

  Future<void> load();
  // async {}

  RemoteContent({this.defaultLoad = true, this.updateController = true}) {
    if (defaultLoad) {
      loadData();
    }
  }

  Future<void> loadData({bool retry = true}) async {
    startLoading(retry: retry);
    try {
      await httpErrorHandler(load());
    } on AppException catch (e) {
      error = e.msg;
    } on ExpiredToken catch (_) {
      if (!retry) {
        await logOut();
        return;
      }
      try {
        error = await renewToken();
        if (error == null && retry) {
          return loadData(retry: false);
        }
      } on LogOutUser catch (_) {
        await logOut();
      } catch (_) {
        error = "Something went wrong";
      }
    } catch (_, s) {
      log(_.runtimeType.toString());
      log(s.toString());
      error = "Something went wrong";
    }
    endLoading();
  }

  void onStartLoading() {}

  void startLoading({bool retry = true}) {
    if (retry) {
      onStartLoading();
      loading = true;
      error = null;
      if (updateController) {
        Future.delayed(const Duration(milliseconds: 100)).then((value) => update());
      }
      afterLoad();
    }
  }

  void afterLoad() {}

  void endLoading() {
    loading = false;
    if (updateController) {
      update();
    }
    if (error == null) {
      afterLoad();
    }
  }
}
