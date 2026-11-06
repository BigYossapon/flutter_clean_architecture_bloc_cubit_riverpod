import 'package:flutter/material.dart';

class RouteObserverService extends NavigatorObserver {
  static String? currentRoute;

  @override
  void didPush(Route route, Route? previousRoute) {
    currentRoute = route.settings.name;
    print(currentRoute);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    currentRoute = previousRoute?.settings.name;
    print(currentRoute);
  }
}
