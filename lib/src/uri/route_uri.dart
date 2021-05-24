part of kingfisher;

enum RouteUriFormat {
  simple,
  indicateParameters,
  excludeExpressions,
  debug,
}

class RouteUri {
  final List<PathSegment> segments;
  final List<String> variables;

  static const notFound = RouteUri();

  factory RouteUri.parse(String route) {
    String path = route;
    while (path.startsWith("/")) path = path.substring(1);
    while (path.endsWith('/')) path = path.substring(0, path.length - 1);

    final List<String> segments = [];
    final List<int> units = path.codeUnits;

    StringBuffer segment = StringBuffer();
    bool isVariable = false;
    int openExpressionCount = 0;
    for (int i = 0; i < units.length; i++) {
      final int code = units[i];

      if (code == _openVariable && openExpressionCount == 0 && !isVariable) {
        if (segment.isNotEmpty) {
          throw FormatException(
            "Improper placement of variable declaration, must be before naming the parameter for route '$route' at position $i",
          );
        }

        isVariable = true;
        segment.writeCharCode(code);
        continue;
      }

      if (code == _closeVariable && (openExpressionCount == 0 || openExpressionCount == -1)) {
        if (!isVariable) {
          throw FormatException("Unable to close an unopened variable segment for route '$route' at position $i");
        }
        if (i + 1 < units.length) {
          if (units[i + 1] != _pathDelimiter) {
            throw FormatException("Segment not ended after variable segment was closed for route '$route' at position $i");
          } else {
            // Skip the '/' character that comes next
            i++;
          }
        }
        segment.writeCharCode(code);

        segments.add(segment.toString());
        segment.clear();
        isVariable = false;
        openExpressionCount = 0;
        continue;
      }

      if (code == _openExpression) {
        // '('
        if (!isVariable)
          throw FormatException(
            "Unable to have regular expression inside static segment for route '$route' at position $i",
          );
        if (openExpressionCount == -1)
          throw FormatException(
            "Unable to have multiple expressions inside a variable segment for route '$route' at position $i",
          );
        if (segment.toString().length == 1) {
          throw FormatException("You cannot have a regular expression before naming a variable");
        }

        openExpressionCount++;
        segment.writeCharCode(code);
        continue;
      }

      if (code == _closeExpression) {
        // ')'
        if (!isVariable) {
          throw FormatException("Cannot close a variable inside of a static segment for route '$route' at position $i");
        }
        if (openExpressionCount <= 0)
          throw FormatException(
            "Cannot close expression that is either already closed or doesn't exist for route $route at position $i",
          );

        openExpressionCount--;
        if (openExpressionCount == 0) openExpressionCount = -1;

        segment.writeCharCode(code);
        continue;
      }

      if (code == _pathDelimiter) {
        // '/'
        if (isVariable) {
          throw FormatException("Tried to close an unclosed variable segment for route '$route' at position $i");
        }
        segments.add(segment.toString());
        segment.clear();

        continue;
      }

      segment.writeCharCode(code);
    }

    if (segment.isNotEmpty) {
      segments.add(segment.toString());
      segment.clear();
    }

    List<String> variables = <String>[];
    List<PathSegment> pathSegments = <PathSegment>[];
    for (final String x in segments) {
      final PathSegment pathSegment = PathSegment.parse(x);
      if (pathSegment.isVariable) variables.add(pathSegment.name);
      pathSegments.add(pathSegment);
    }
    return RouteUri(
      segments: pathSegments,
      variables: variables,
    );
  }

  const RouteUri({
    this.segments = const [],
    this.variables = const [],
  });

  @override
  String toString({RouteUriFormat format = RouteUriFormat.simple}) {
    if (format == RouteUriFormat.debug)
      return 'RouteUri{'
          '\n  segments: ${_listToString<PathSegment>(segments, (e) => e.toString(format: format))},'
          '\n  variables: ${_listToString(variables)})'
          '}';
    return segments.fold('', (v, x) => v + x.toString(format: format));
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RouteUri &&
          runtimeType == other.runtimeType &&
          listEquals(segments, other.segments) &&
          listEquals(variables, other.variables);

  @override
  int get hashCode => variables.hashCode ^ segments.hashCode;
}
