class networkResponse {
  final bool isSuccess;
  final int statusCode;
  dynamic responseData;
  String errorMsg = '';

  networkResponse(
      {required this.statusCode,
      required this.isSuccess,
      this.responseData,
      this.errorMsg = 'Invalid login credentials'});
}
