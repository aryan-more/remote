import 'dart:developer';

import 'package:get/get.dart';
import 'package:remote/error_handler/error.dart';
import 'package:remote/static/remote.dart';

abstract class RemoteContent extends GetxController {
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

  Future<bool> loadData({bool retry = true}) async {
    startLoading(retry: retry);
    try {
      await load();
    } on AppException catch (e) {
      error = e.msg;
    } on ExpiredToken catch (_) {
      if (!retry) {
        await Remote.logOut();
        return false;
      }
      try {
        error = await Remote.renewToken();
        if (error == null && retry) {
          return loadData(retry: false);
        }
      } on LogOutUser catch (_) {
        await Remote.logOut();
      } catch (_) {
        error = "Something went wrong";
      }
    } catch (e, s) {
      if (Remote.customErrorHandler.containsKey(e.runtimeType)) {
        error = Remote.customErrorHandler[e.runtimeType]!(e);
      } else {
        Remote.logError(e, s);
        log(e.runtimeType.toString());
        log(s.toString());
        error = "Something went wrong";
      }
    }
    endLoading();
    return error == null;
  }

  void onStartLoading() {}

  void startLoading({bool retry = true}) {
    if (retry) {
      onStartLoading();
      loading = true;
      error = null;
      if (updateController) {
        Future.delayed(const Duration(milliseconds: 100))
            .then((value) => update());
      }
      afterLoadStart();
    }
  }

  void afterLoadStart() {}

  void afterLoadEnd() {}

  void endLoading() {
    loading = false;
    if (updateController) {
      update();
    }
    if (error == null) {
      afterLoadEnd();
    }
  }
}
