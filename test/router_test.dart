import 'package:kingfisher/kingfisher.dart';

class NavResult {
  final int data;

  const NavResult(this.data);

  @override
  String toString() {
    return 'NavResult($data)';
  }
}

void main() async {
  final Router<NavResult> router = Router()
    ..route('/something').linkFunction((request) {
      return RouteResponse.success(const NavResult(1));
    });

  final result = await router.handle('/something');
}
