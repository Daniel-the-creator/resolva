import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';

/// Centralized route guard for protected RESOLVA services, marketplaces, and dashboard.
///
/// Restricts access to authenticated, onboarded, and PIN-verified users only.
/// Any unauthenticated or partially-onboarded navigation is intercepted and routed
/// to the appropriate authentication checkpoint or onboarding step.
class AuthGuard extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final authController = Get.find<AuthController>();

    // 1. Not logged in -> redirect to login, preserving requested target route
    if (!authController.isLoggedIn.value) {
      if (route != null &&
          route.isNotEmpty &&
          route != '/login' &&
          route != '/register') {
        authController.intendedRoute.value = route;
      }
      return const RouteSettings(name: '/login');
    }

    // 2. Terms of Service & Privacy Policy acceptance required
    if (!authController.hasAcceptedCurrentPolicies) {
      if (route != null &&
          route.isNotEmpty &&
          route != '/policy-acceptance') {
        authController.intendedRoute.value = route;
      }
      return const RouteSettings(name: '/policy-acceptance');
    }

    // 3. Security PIN creation required (new user)
    if (!authController.hasConfiguredPin) {
      if (route != null &&
          route.isNotEmpty &&
          route != '/create-pin' &&
          route != '/confirm-pin') {
        authController.intendedRoute.value = route;
      }
      return const RouteSettings(name: '/create-pin');
    }

    // 4. Returning user PIN verification required for active session
    if (!authController.isSessionUnlocked.value) {
      if (route != null &&
          route.isNotEmpty &&
          route != '/verify-pin' &&
          route != '/forgot-pin') {
        authController.intendedRoute.value = route;
      }
      return const RouteSettings(name: '/verify-pin');
    }

    // User is fully authorized and session is unlocked
    return null;
  }
}

/// Guard protecting onboarding screens from logged-out visitors.
class OnboardingGuard extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final authController = Get.find<AuthController>();
    if (!authController.isLoggedIn.value) {
      return const RouteSettings(name: '/login');
    }
    return null;
  }
}
