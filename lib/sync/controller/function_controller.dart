part of kingfisher;

class _FunctionController<T> extends RouteController<T> {
  final CallbackRouteHandler<T> handler;

  _FunctionController(this.handler);

  @override
  RouteResponse<T> handle(RouteRequest<T> request) => handler(request);
}
