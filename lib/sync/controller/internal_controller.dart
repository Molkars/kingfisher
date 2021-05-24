part of kingfisher;

class _InternalController<T> extends SequentialController<T> {
  final List<RouteUri> uris;

  _InternalController({
    this.uris = const [],
  });

  @override
  RouteResponse<T> handle(RouteRequest<T> request) {
    return _next?.handle(request) ?? request;
  }
}
