part of kingfisher;

class PathSegment {
  final String name;
  final RegExp? matcher;
  final bool isVariable;

  const PathSegment(
    this.name, {
    this.isVariable = false,
    this.matcher,
  });

  factory PathSegment.parse(String pathSegment) {
    final bool isVariable = pathSegment.startsWith("{");
    if (pathSegment.startsWith('{')) pathSegment = pathSegment.substring(1);
    if (pathSegment.endsWith('}')) pathSegment = pathSegment.substring(0, pathSegment.length - 1);

    int regexIndex = pathSegment.indexOf('(');
    RegExp? matcher;
    if (regexIndex != -1) {
      String regexString = pathSegment.substring(regexIndex);

      final List<int> codeUnits = regexString.codeUnits;
      assert(codeUnits.length >= 3);
      if (codeUnits[1] != '^'.codeUnitAt(0)) {
        regexString = regexString.substring(0, 1) + '^' + regexString.substring(1);
      }
      if (codeUnits[codeUnits.length - 1] != r'$'.codeUnitAt(0)) {
        regexString = regexString.substring(0, codeUnits.length) + r'$' + regexString.substring(codeUnits.length);
      }

      matcher = RegExp(regexString);
      pathSegment = pathSegment.substring(0, regexIndex);
    }

    return PathSegment(pathSegment, isVariable: isVariable, matcher: matcher);
  }

  @override
  String toString({RouteUriFormat format = RouteUriFormat.simple}) {
    switch (format) {
      case RouteUriFormat.simple:
        return name;
      case RouteUriFormat.indicateParameters:
        return matcher != null ? '{$name${matcher!.pattern}' : '{$name}';
      case RouteUriFormat.excludeExpressions:
        return '{$name}';
      case RouteUriFormat.debug:
        return 'PathSegment{'
            '\n  name: $name,'
            '\n  matcher: $matcher,'
            '\n  isVariable: $isVariable'
            '}';
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PathSegment &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          matcher == other.matcher &&
          isVariable == other.isVariable;

  @override
  int get hashCode => name.hashCode ^ matcher.hashCode ^ isVariable.hashCode;
}
