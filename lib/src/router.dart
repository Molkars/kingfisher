part of kingfisher;

class Router<T> {
  List<_InternalController<T>> _controllers = [];

  Linkable<T> route(String route) {
    final List<RouteUri> uris = _degenerifyRoute(route);
    final _controller = _InternalController<T>(uris: uris);
    _controllers.add(_controller);
    return _controller;
  }

  FutureOr<RouteResponse<T>> handle(
    String route, {
    RequestHeaders<T> headers = const BasicRequestHeaders.empty(),
    RequestBody<T> body = const JsonRequestBody.empty(),
  }) async {
    final Uri parsed = Uri.parse(route);
    RouteRequest<T>? _request;
    _InternalController<T>? _controller;

    for (final _InternalController<T> controller in _controllers) {
      for (final RouteUri uri in controller.uris) {
        if (uri.segments.length != parsed.pathSegments.length) {
          continue;
        }

        bool isMatch = true;
        final Map<String, String> variables = {};
        for (int i = 0; i < uri.segments.length; i++) {
          final PathSegment segment = uri.segments[i];
          final String intent = parsed.pathSegments[i];

          if (segment.isVariable) {
            if (segment.matcher != null) {
              if (!segment.matcher!.hasMatch(intent)) {
                isMatch = false;
                break;
              }
            }
            variables[segment.name] = intent;
            continue;
          }

          if (segment.name != intent) {
            isMatch = false;
            break;
          }
        }

        if (!isMatch) {
          continue;
        }

        if (_request != null) {
          print(
            '[Kingfisher] Found an additional possible route for intent $route, $uri may conflict',
          );
          continue;
        }

        _request = RouteRequest<T>(
          location: uri,
          headers: headers,
          body: body,
          pathVariables: variables,
          queryParameters: parsed.queryParameters,
        );
        _controller = controller;
      }
    }

    if (_request == null) {
      _request = RouteRequest(location: RouteUri.notFound);
      return _notFound(_request);
    }

    late RouteResponse<T> _response;
    do {
      _response = await _controller!.handle(_request);
    } while (_response is RouteRequest<T>);

    return _response;
  }

  FutureOr<RouteResponse<T>> _notFound(RouteRequest<T> request) {
    // if (_notFoundController == null) {
    throw Exception('Unable to handle case ${request.location}');
    // }
    // return _notFoundController!.handle(request);
  }
}

class RouteRequest<T> extends RouteResponse<T> {
  final RequestHeaders<T> headers;
  final RequestBody<T> body;
  final Map<String, String> pathVariables;
  final Map<String, String> queryParameters;
  final RouteUri location;

  const RouteRequest({
    required this.location,
    this.pathVariables = const {},
    this.queryParameters = const {},
    this.headers = const BasicRequestHeaders.empty(),
    this.body = const JsonRequestBody.empty(),
  });
}
