part of kingfisher;

class Kingfisher<T> {
  List<_InternalController<T>> _controllers = [];
  _InternalController<T>? _notFoundController;

  Linkable<T> route(String route) {
    final List<RouteUri> uris = _degenerifyRoute(route);
    final _controller = _InternalController<T>(uris: uris);
    _controllers.add(_controller);
    return _controller;
  }

  Linkable<T> notFound() => _notFoundController = _InternalController<T>();

  FutureOr<RouteResponse<T>> get(
    String route, {
    RequestHeaders<T> headers = const BasicRequestHeaders.empty(),
    RequestBody<T> body = const JsonRequestBody.empty(),
  }) async {
    RouteResponse<T> response = IRouteRequest(location: route, body: body, headers: headers);

    do {
      final request = response as IRouteRequest<T>;
      final intent = _handle(route: request.location, headers: request.headers, body: request.body);
      if (intent.request == null) {
        var _request = RouteRequest<T>._(endpointUri: RouteUri.notFound, location: request.location);
        response = await _notFound(_request);
        continue;
      }

      response = await intent.controller!.handle(intent.request!);
    } while (response is IRouteRequest<T>);

    return response;
  }

  _RouterIntent<T> _handle({
    required String route,
    required RequestBody<T> body,
    required RequestHeaders<T> headers,
  }) {
    final raw = Uri.parse(route);
    _RouterIntent<T>? intent;

    for (final _InternalController<T> controller in _controllers) {
      for (final RouteUri uri in controller.uris) {
        if (uri.segments.length != raw.pathSegments.length) {
          continue;
        }

        bool isMatch = true;
        final Map<String, String> variables = {};
        for (int i = 0; i < uri.segments.length; i++) {
          final PathSegment segment = uri.segments[i];
          final String intent = raw.pathSegments[i];

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

        if (intent != null) {
          print('[Kingfisher] Found an additional possible route for intent $route, $uri may conflict');
          continue;
        }

        intent = _RouterIntent<T>(
          request: RouteRequest<T>._(
            endpointUri: uri,
            location: route,
            headers: headers,
            body: body,
            pathVariables: variables,
            queryParameters: raw.queryParameters,
          ),
          controller: controller,
        );
      }
    }

    return intent ?? _RouterIntent();
  }

  FutureOr<RouteResponse<T>> _notFound(RouteRequest<T> request) {
    if (_notFoundController == null) {
      throw Exception('Unable to handle case ${request.location}');
    }
    return _notFoundController!.handle(request);
  }
}

class _RouterIntent<T> {
  final _InternalController<T>? controller;
  final RouteRequest<T>? request;

  const _RouterIntent({
    this.controller,
    this.request,
  });
}
