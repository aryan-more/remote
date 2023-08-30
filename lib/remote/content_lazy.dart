import 'package:remote/remote/content.dart';

abstract class RemoteContentLazy<T> extends RemoteContent {
  RemoteContentLazy({
    super.defaultLoad,
    super.updateController,
  });

  int get length => data.length + (hasMore ? 1 : 0);

  final limit = 10;
  final List<T> data = [];
  bool init = true;
  int round = 0;
  bool hasMore = true;
  int oldLength = 0;

  Future<void> flush() async {
    init = true;
    round = 0;
    hasMore = true;
    oldLength = 0;
    data.clear();
    await lazyLoad();
  }

  bool checkLimit() => data.length % limit != 0;

  int get offset => round * limit;

  void onLoadEnd() {}

  void onEnd() {
    if (error == null) {
      init = false;
      if (oldLength == data.length || checkLimit()) {
        hasMore = false;
      }
      round++;
      onLoadEnd();
    }
  }

  @override
  void endLoading() {
    onEnd();
    super.endLoading();
  }

  Future<void> lazyLoad() async {
    if (!loading || init) {
      oldLength = data.length;
      await super.loadData();
    }
  }

  @override
  Future<void> loadData({bool retry = true}) async => lazyLoad();
}
