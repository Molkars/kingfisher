part of kingfisher;

abstract class RequestHeaders<T> {
  Map<String, String> get headers;

  const RequestHeaders();

  Map<String, String> stringify();
}

class BasicRequestHeaders<T> extends RequestHeaders<T> {
  final Map<String, String> headers;

  const BasicRequestHeaders(this.headers);

  const BasicRequestHeaders.empty() : this(const {});

  @override
  Map<String, String> stringify() => headers;
}