part of kingfisher;

abstract class RouteResponse<T> {
  const RouteResponse();

  const factory RouteResponse.redirect(String newRoute) = RedirectResponse<T>;

  const factory RouteResponse.request({
    required RouteUri location,
    RequestHeaders<T> headers,
    RequestBody<T> body,
  }) = RouteRequest<T>;

  const factory RouteResponse.notFound([String message]) = NotFoundResponse<T>;

  const factory RouteResponse.success(T data) = SuccessResponse<T>;
}

class RedirectResponse<T> extends RouteResponse<T> {
  final String newRoute;

  const RedirectResponse(this.newRoute);
}

class NotFoundResponse<T> extends RouteResponse<T> {
  final String message;

  const NotFoundResponse([this.message = ""]);
}

class SuccessResponse<T> extends RouteResponse<T> {
  final T data;

  const SuccessResponse(this.data);
}