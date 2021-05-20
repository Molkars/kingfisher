part of kingfisher;

bool listEquals(List a, List b) {
  if (identical(a, b)) return true;
  if (a.length != b.length) return false;
  for (int i = 0; i < a.length; i++) if (a[i] != b[i]) return false;
  return true;
}

String _listToString<E>(List<E>? list, [String Function(E element)? stringifier]) {
  if (list == null) return 'null';
  String str = '[';
  for (final segment in list) {
    final string = stringifier?.call(segment) ?? segment.toString();
    if (string.length < 40)
      str += ' $string,';
    else
      str += "\n  $string,";
  }
  str += ']';
  return str;
}

List<RouteUri> _degenerifyRoute(final String route) {
  var routePattern = route;
  var endingOptionalCloseCount = 0;
  while (routePattern.endsWith("]")) {
    routePattern = routePattern.substring(0, routePattern.length - 1);
    endingOptionalCloseCount++;
  }

  final List<int> codeUnits = routePattern.codeUnits;
  final List<RouteUri> patterns = <RouteUri>[];
  final StringBuffer buffer = StringBuffer();

  bool insideExpression = false;
  for (final int code in codeUnits) {
    if (code == _openExpression) {
      if (insideExpression) {
        throw ArgumentError(
            "Router compilation failed. Route pattern '$routePattern' cannot use expression that contains '(' or ')'");
      }
      buffer.writeCharCode(code);
      insideExpression = true;
      continue;
    }

    if (code == _closeExpression) {
      if (!insideExpression) {
        throw ArgumentError(
            "Router compilation failed. Route pattern '$routePattern' cannot use expression that contains '(' or ')'");
      }
      buffer.writeCharCode(code);
      insideExpression = false;
      continue;
    }

    if (code == _openOptional) {
      if (insideExpression) {
        buffer.writeCharCode(code);
      } else {
        patterns.add(RouteUri.parse(buffer.toString()));
      }
      continue;
    }

    buffer.writeCharCode(code);
  }

  if (insideExpression) {
    throw ArgumentError("Route '$routePattern' has an unterminated regular expression.");
  }

  if (endingOptionalCloseCount != patterns.length) {
    throw ArgumentError("Route '$routePattern' does not close all optionals.");
  }

  // Add the final pattern - if no optionals, this is the only pattern.
  // Reverse the list so that the longest routes are first
  return (patterns..insert(0, RouteUri.parse(buffer.toString()))).reversed.toList();
}
