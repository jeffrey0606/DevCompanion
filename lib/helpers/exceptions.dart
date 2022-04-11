class InitAppConfigsException implements Exception {
  String _message;
  InitAppConfigsException(this._message);
  set message(String msg) {
    _message = msg;
  }

  String get message => _message;
}
