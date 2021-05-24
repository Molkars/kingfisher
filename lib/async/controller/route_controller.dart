part of kingfisher;

abstract class SequentialController<T> extends RouteController<T> {
  RouteController<T>? _next;

  @override
  FutureOr<RouteResponse<T>> handle(RouteRequest<T> request) {
    return _next?.handle(request) ?? RouteResponse.notFound("No sequential route provided");
  }

  @override
  Linkable<T> link(RouteController<T> Function() factory) => _next = factory();

  @override
  Linkable<T> linkFunction(CallbackRouteHandler<T> handle) => _next = _FunctionController(handle);
}

abstract class RouteController<T> with Linkable<T> {
  FutureOr<RouteResponse<T>> handle(RouteRequest<T> request);

  @override
  Linkable<T> link(RouteController<T> Function() factory) {
    throw UnsupportedError("You cannot link another controller to a $runtimeType");
  }

  @override
  Linkable<T> linkFunction(CallbackRouteHandler<T> handle) {
    throw UnsupportedError("You cannot link another controller to a $runtimeType");
  }
}
