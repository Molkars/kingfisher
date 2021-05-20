part of kingfisher;

abstract class RequestHeaders<T> {
  Map<String, String> get raw;

  const RequestHeaders();

  Map<String, String> stringify();

  @override
  String toString() => 'RequestHeaders{headers: $raw}';
}

class BasicRequestHeaders<T> extends RequestHeaders<T> {
  final Map<String, String> raw;

  const BasicRequestHeaders(this.raw);

  const BasicRequestHeaders.empty() : this(const {});

  @override
  Map<String, String> stringify() => raw;

  @override
  String toString() => 'BasicRequestHeaders{headers: $raw}';
}
