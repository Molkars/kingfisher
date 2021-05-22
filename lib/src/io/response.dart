part of kingfisher;

abstract class RouteResponse<T> {
  const RouteResponse();

  const factory RouteResponse.redirect({
    required String previousLocation,
    required String newLocation,
    RequestHeaders headers,
    RequestBody body,
  }) = RedirectResponse<T>;

  const factory RouteResponse.request({
    required String location,
    RequestHeaders headers,
    RequestBody body,
  }) = IRouteRequest<T>;

  const factory RouteResponse.notFound([String message]) = NotFoundResponse<T>;

  const factory RouteResponse.success(T data) = SuccessResponse<T>;

  const factory RouteResponse.unauthorized([String message]) = UnauthorizedResponse<T>;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is RouteResponse && runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;
}

class NotFoundResponse<T> extends RouteResponse<T> {
  final String message;

  const NotFoundResponse([this.message = ""]);

  @override
  String toString() => 'NotFoundResponse{message: $message}';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotFoundResponse && runtimeType == other.runtimeType && message == other.message;

  @override
  int get hashCode => message.hashCode;
}

class SuccessResponse<T> extends RouteResponse<T> {
  final T data;

  const SuccessResponse(this.data);

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

  const UnauthorizedResponse([this.message]);

  @override
  String toString() => 'UnauthorizedResponse{message: $message}';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UnauthorizedResponse && runtimeType == other.runtimeType && message == other.message;

  @override
  int get hashCode => message.hashCode;
}
