import 'package:kingfisher/kingfisher.dart';
import 'package:test/test.dart';

void main() {
  group('Uri Tests', () {
    test('Simple URI', () {
      final expected = RouteUri(
        segments: [
          PathSegment('something'),
        ],
      );
      final actual = RouteUri.parse('/something');

      expect(actual, equals(expected));
    });

    test('Variable URI', () {
      final expectedWORegex = RouteUri(
        variables: [
          "where",
        ],
        segments: [
          PathSegment("some"),
          PathSegment("where", isVariable: true),
        ],
      );
      final actualWORegex = RouteUri.parse("/some/{where}");

      expect(actualWORegex, equals(expectedWORegex));

      final expectedWRegex = RouteUri(
        variables: ["where"],
        segments: [
          PathSegment("some"),
          PathSegment("where", isVariable: true, matcher: RegExp(r"(^[a-z]+$)")),
        ],
      );
      final actualWRegex = RouteUri.parse("/some/{where([a-z]+)}");
      expect(actualWRegex, equals(expectedWRegex));
    });

    test('Mixed URI', () {
      final expected = RouteUri(
        segments: [
          PathSegment('api'),
          PathSegment('users'),
          PathSegment('userId', isVariable: true),
          PathSegment('notes'),
          PathSegment('noteId', isVariable: true, matcher: RegExp(r"(^\d+$)")),
        ],
        variables: ['userId', 'noteId'],
      );
      final actual = RouteUri.parse('/api/users/{userId}/notes/{noteId(\\d+)}');

      expect(actual, equals(expected));
    });
  });
}
