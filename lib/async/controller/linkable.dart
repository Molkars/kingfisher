part of kingfisher;

typedef CallbackRouteHandler<T> = FutureOr<RouteResponse<T>> Function(RouteRequest<T> request);

mixin Linkable<T> {
  Linkable<T> link(RouteController<T> Function() factory);

  Linkable<T> linkFunction(CallbackRouteHandler<T> handle);
}
