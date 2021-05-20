part of kingfisher;

@immutable
abstract class RequestBody<T> {
  const RequestBody();

  Map<String, String> stringify();
}

@immutable
class JsonRequestBody<T> extends RequestBody<T> {
  final Map<String, dynamic> json;

  const JsonRequestBody(this.json);

  const JsonRequestBody.empty() : this(const {});

  @override
  Map<String, String> stringify() => json.map((k, v) => MapEntry(k, v.toString()));

  @override
  String toString() => 'JsonRequestBody{json: $json}';
}
