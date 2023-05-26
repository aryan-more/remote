class ExpiredToken {}

class LogOutUser {}

class AppExceptionNonRetryable {
  static const Set<String> _reasons = {'Record not found.', "Order not found.", "Meeting not found."};
  static bool doesNotContains(String error) => !_reasons.contains(error);
}

class AppException extends Error {
  final String msg;

  AppException(this.msg);
  @override
  String toString() {
    return msg;
  }
}
