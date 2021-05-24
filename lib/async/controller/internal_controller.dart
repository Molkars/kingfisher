part of kingfisher;

class _InternalController<T> extends SequentialController<T> {
  final List<RouteUri> uris;

  _InternalController({
    this.uris = const [],
  });

  @override
  Future<RouteResponse<T>> handle(RouteRequest<T> request) async {
    return await _next?.handle(request) ?? request;
  }
}
