import 'package:flutter/material.dart';

class RouterService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<T?>? push<T>(Widget page, {Duration duration = const Duration(milliseconds: 400)}) {
    return navigatorKey.currentState?.push<T>(_fadeRoute(page, duration: duration));
  }

  void pop<T extends Object?>([T? result]) {
    navigatorKey.currentState?.pop(result);
  }

  Future<T?>? pushAndRemoveUntil<T>(
      Widget page,
      bool Function(Route<dynamic>) predicate,
      {Duration duration = const Duration(milliseconds: 400)}
      ) {
    return navigatorKey.currentState?.pushAndRemoveUntil<T>(
      _fadeRoute(page, duration: duration),
      predicate,
    );
  }

  Future<T?>? pushReplacement<T, TO>(
      Widget page,
      {TO? result, Duration duration = const Duration(milliseconds: 400)}
      ) {
    return navigatorKey.currentState?.pushReplacement<T, TO>(
      _fadeRoute(page, duration: duration),
      result: result,
    );
  }

  Future<T?>? pushNamedAndRemoveUntil<T>(
      String routeName,
      bool Function(Route<dynamic>) predicate,
      {Object? arguments}
      ) {
    return navigatorKey.currentState?.pushNamedAndRemoveUntil<T>(
      routeName,
      predicate,
      arguments: arguments,
    );
  }

  void popUntil(bool Function(Route<dynamic>) predicate) {
    navigatorKey.currentState?.popUntil(predicate);
  }

  bool canPop() {
    return navigatorKey.currentState?.canPop() ?? false;
  }

  void maybePop<T extends Object?>([T? result]) {
    navigatorKey.currentState?.maybePop(result);
  }

  Route<T> _fadeRoute<T>(Widget page, {required Duration duration}) {
    return PageRouteBuilder<T>(
      transitionDuration: duration,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }
}

final router = RouterService();