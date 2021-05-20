part of kingfisher;

class RouteRequest<T> extends IRouteRequest<T> {
  final Map<String, String> pathVariables;
  final Map<String, String> queryParameters;
  final RouteUri endpointUri;

  const RouteRequest._({
    required this.endpointUri,
    required String location,
    this.pathVariables = const {},
    this.queryParameters = const {},
    RequestHeaders<T> headers = const BasicRequestHeaders.empty(),
    RequestBody<T> body = const JsonRequestBody.empty(),
  }) : super(
          headers: headers,
          body: body,
          location: location,
        );

  @override
  String toString() {
    return 'RouteRequest{location: $location, headers: $headers, body: $body, pathVariables: $pathVariables, queryParameters: $queryParameters, endpointUri: $endpointUri}';
  }
}

class IRouteRequest<T> extends RouteResponse<T> {
  final String location;
  final RequestHeaders<T> headers;
  final RequestBody<T> body;

  const IRouteRequest({
    required this.location,
    this.headers = const BasicRequestHeaders.empty(),
    this.body = const JsonRequestBody.empty(),
  });

  @override
  String toString() {
    return 'RouteRequest{location: $location, headers: $headers, body: $body}';
  }
}

class RedirectResponse<T> extends IRouteRequest<T> {
  final String previousLocation;

  const RedirectResponse({
    required this.previousLocation,
    required String newLocation,
    RequestHeaders<T> headers = const BasicRequestHeaders.empty(),
    RequestBody<T> body = const JsonRequestBody.empty(),
  }) : super(
          headers: headers,
          body: body,
          location: newLocation,
        );

  @override
  String toString() {
    return 'RouteRequest{location: $location, headers: $headers, body: $body, previousLocation: $previousLocation}';
  }
}
