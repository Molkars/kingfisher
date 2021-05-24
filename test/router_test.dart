import 'dart:async';

import 'package:kingfisher/async.dart';
import 'package:test/scaffolding.dart';
import 'package:test/test.dart';

class DataClass {
  final data;

  const DataClass(this.data);

  @override
  String toString() => 'NavResult($data)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is DataClass && runtimeType == other.runtimeType && data == other.data;

  @override
  int get hashCode => data.hashCode;
}

class DatabaseConnection {
  static final DatabaseConnection instance = DatabaseConnection();

  final Set<String> _authorized = {'a93hpkdf-0'};

  Future<bool> hasAccess(String? userId) => userId == null
      ? Future.value(false)
      : Future.delayed(Duration(milliseconds: 483), () => _authorized.contains(userId));
}

class AuthorizerController extends SequentialController<DataClass> {
  @override
  FutureOr<RouteResponse<DataClass>> handle(request) async {
    if (request.headers.raw.containsKey('Bearer') &&
        await DatabaseConnection.instance.hasAccess(request.headers.raw['Bearer'])) {
      return super.handle(request);
    }
    return RouteResponse.unauthorized();
  }
}

class SomeController extends SequentialController<DataClass> {
  @override
  FutureOr<RouteResponse<DataClass>> handle(RouteRequest<DataClass> request) {
    if (request.pathVariables.containsKey('id')) {
      return RouteResponse.success(DataClass('with_${request.pathVariables['id']!}'));
    }
    return RouteResponse.success(DataClass('without_id'));
  }
}

void main() async {
  late final Kingfisher<DataClass> router;
  setUpAll(() {
    router = Kingfisher()
      ..route('/something').linkFunction((request) => RouteResponse.success(const DataClass(1)))
      ..route(r'/something/{number(-?\d+)}')
          .linkFunction((request) => RouteResponse.success(DataClass(int.parse(request.pathVariables['number']!))))
      ..route('/redirect')
          .linkFunction((request) => RouteResponse.redirect(newLocation: '/something', previousLocation: '/redirect'))
      ..route('/restricted')
          .link(() => AuthorizerController())
          .linkFunction((request) => RouteResponse.success(DataClass("Authorized!")))
      ..route('/some/[{id}]').link(() => SomeController());
  });

  test('Something Endpoint', () async {
    final actualNoPathVariable = await router.get('/something');
    final expectedNoPathVariable = RouteResponse.success(const DataClass(1));
    expect(actualNoPathVariable, equals(expectedNoPathVariable));

    final actualWithPathVariable = await router.get('/something/9');
    final expectedWithPathVariable = RouteResponse.success(const DataClass(9));
    expect(actualWithPathVariable, equals(expectedWithPathVariable));
  });

  test('Redirect request', () async {
    final actual = await router.get('/redirect');

    // Should redirect to the /something endpoint
    final expected = RouteResponse.success(const DataClass(1));
    expect(actual, equals(expected));
  });

  test('Authorization Endpoint', () async {
    final actualInvalidCreds = await router.get('/restricted');
    final expectedInvalidCreds = RouteResponse<DataClass>.unauthorized();
    expect(actualInvalidCreds, equals(expectedInvalidCreds));

    final actualValidCreds = await router.get('/restricted', headers: BasicRequestHeaders({'Bearer': 'a93hpkdf-0'}));
    final expectedValidCreds = RouteResponse.success(const DataClass("Authorized!"));
    expect(actualValidCreds, equals(expectedValidCreds));
  });

  test('Non existent endpoint', () async {
    // No handling
    try {
      await router.get('/non-existent');
    } on Exception catch (e) {
      expect(e.toString(), equals(Exception('Unable to handle case /non-existent').toString()));
    }
    // Link the not found controller
    router.notFound().linkFunction((request) => RouteResponse.notFound("Couldn't find ${request.location}"));
    expect(await router.get('/non-existent'), equals(RouteResponse<DataClass>.notFound("Couldn't find /non-existent")));
  });

  test('Optional path variable', () async {
    expect(await router.get('/some'), equals(RouteResponse.success(DataClass('without_id'))));
    expect(await router.get('/some/1'), equals(RouteResponse.success(DataClass('with_1'))));
  });
}
