import 'package:remote/remote/content.dart';

abstract class RemoteContentResult<T> extends RemoteContent {
  T? data;
  RemoteContentResult({
    super.defaultLoad,
    super.updateController,
  });

  @override
  void startLoading({bool retry = true}) {
    data = null;
    super.startLoading(retry: retry);
  }

  @override
  void endLoading() {
    if (error == null && data == null) {
      error = 'Something went wrong';
    }
    super.endLoading();
  }
}
