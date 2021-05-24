part of kingfisher;

abstract class RouteResponse<T> {
  final ResponseType responseType;

  const RouteResponse(this.responseType);

  int getCode([Map<ResponseType, int> responseCodes = defaultResponseCodes]) {
    return responseCodes[responseType] ?? -1;
  }

  const factory RouteResponse.redirect({
    required String previousLocation,
    required String newLocation,
    RequestHeaders headers,
    RequestBody body,
  }) = RedirectResponse<T>;

  const factory RouteResponse.request({
    required ResponseType responseType,
    required String location,
    RequestHeaders headers,
    RequestBody body,
  }) = IRouteRequest<T>;

  const factory RouteResponse.notFound([String message]) = NotFoundResponse<T>;

  const factory RouteResponse.success(T data) = SuccessResponse<T>;

  const factory RouteResponse.ok(T data) = OkResponse<T>;

  const factory RouteResponse.unauthorized([String message]) = UnauthorizedResponse<T>;

  @override
  bool operator ==(Object other) => identical(this, other) || other is RouteResponse && runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;
}

class NotFoundResponse<T> extends RouteResponse<T> {
  final String message;

  const NotFoundResponse([this.message = ""]) : super(ResponseType.notFound);

  @override
  String toString() => 'NotFoundResponse{message: $message}';

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is NotFoundResponse && runtimeType == other.runtimeType && message == other.message;

  @override
  int get hashCode => message.hashCode;
}

typedef OkResponse<T> = SuccessResponse<T>;

class SuccessResponse<T> extends RouteResponse<T> {
  final T data;

  const SuccessResponse(this.data) : super(ResponseType.ok);

  @override
  String toString() => 'SuccessResponse{data: $data}';

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is SuccessResponse && runtimeType == other.runtimeType && data == other.data;

  @override
  int get hashCode => data.hashCode;
}

class UnauthorizedResponse<T> extends RouteResponse<T> {
  final String? message;

  const UnauthorizedResponse([this.message]) : super(ResponseType.unauthorized);

  @override
  String toString() => 'UnauthorizedResponse{message: $message}';

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is UnauthorizedResponse && runtimeType == other.runtimeType && message == other.message;

  @override
  int get hashCode => message.hashCode;
}
