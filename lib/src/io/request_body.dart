part of kingfisher;

@immutable
abstract class RequestBody {
  const RequestBody();

  Map<String, String> stringify();
}

@immutable
class JsonRequestBody extends RequestBody {
  final Map<String, dynamic> json;

  const JsonRequestBody(this.json);

  const JsonRequestBody.empty() : this(const {});

  @override
  Map<String, String> stringify() => json.map((k, v) => MapEntry(k, v.toString()));

  @override
  String toString() => 'JsonRequestBody{json: $json}';
}
