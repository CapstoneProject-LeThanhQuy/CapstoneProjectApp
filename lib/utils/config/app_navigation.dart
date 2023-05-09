import '../extension/route_type.dart';
import 'app_route.dart';

class N {
  static void toDemoPage({RouteType type = RouteType.offAll}) {
    type.navigate(name: AppRoute.demo);
  }

  static void toLandingPage({RouteType type = RouteType.offAll}) {
    type.navigate(name: AppRoute.landing);
  }

  static void toRegisterPage({RouteType type = RouteType.to}) {
    type.navigate(name: AppRoute.register);
  }

  static void toHomePage({RouteType type = RouteType.offAll}) {
    type.navigate(name: AppRoute.home);
  }
}
