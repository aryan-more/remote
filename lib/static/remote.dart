import 'package:remote/static/type.dart';

class Remote {
  static RemoteErrorLogger? _logger;

  static set logger(RemoteErrorLogger log) => _logger = log;

  static void logError(dynamic e, StackTrace s) {
    if (_logger != null) {
      _logger!(e, s);
    }
  }

  static late final LogOut logOut;

  static late final ShowLoading showLoading;

  static late final ShowError showError;

  static late final RenewToken renewToken;

  static void init({
    required LogOut logOutFunc,
    required ShowLoading showLoadingFunc,
    required ShowError showErrorFunc,
    required RenewToken renewTokenFunc,
  }) {
    logOut = logOutFunc;
    showLoading = showLoadingFunc;
    showError = showErrorFunc;
    renewToken = renewTokenFunc;
  }
}

typedef RemoteErrorLogger = Function(dynamic e, StackTrace s);
