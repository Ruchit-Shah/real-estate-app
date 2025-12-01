// ignore: constant_identifier_names
enum Status { INITIAL, LOADING, COMPLETE, ERROR }

enum APIType { aPost, aGet, aDelete, aPut }

enum Environment { production, staging }

enum ValidationType { password, email, pNumber }

class ApiResponse<T> {
  T? data;
  String? message;
  Status? status;

  ApiResponse.initial([this.message]) : status = Status.INITIAL;

  ApiResponse.loading([this.message]) : status = Status.LOADING;

  ApiResponse.error([this.message]) : status = Status.ERROR;

  ApiResponse.complete([this.data]) : status = Status.COMPLETE;
}
