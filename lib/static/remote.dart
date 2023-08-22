class Remote {
  static RemoteErrorLogger? _logger;

  static set logger(RemoteErrorLogger log) => _logger = log;

  static void logError(dynamic e, StackTrace s) {
    if (_logger != null) {
      _logger!(e, s);
    }
  }
}

typedef RemoteErrorLogger = Function(dynamic e, StackTrace s);
