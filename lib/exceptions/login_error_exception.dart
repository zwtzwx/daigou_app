class LoginErrorException implements Exception {
  final String? msg;
  LoginErrorException(this.msg);

  @override
  String toString() => msg ?? 'Error';
}
