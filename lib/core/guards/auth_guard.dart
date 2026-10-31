import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';

/// Centralized route guard for protected RESOLVA customer services, marketplaces, and dashboard.
///
/// Restricts access to authenticated, onboarded, PIN-verified CUSTOMER users only.
/// Administrators are strictly isolated from customer dashboard/service routes and
/// redirected to `/admin`.
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
        authController.intendedRoute = route;
      }
      return const RouteSettings(name: '/login');
    }

    // 2. Terms of Service & Privacy Policy acceptance required
    if (!authController.hasAcceptedCurrentPolicies) {
      if (route != null &&
          route.isNotEmpty &&
          route != '/policy-acceptance') {
        authController.intendedRoute = route;
      }
      return const RouteSettings(name: '/policy-acceptance');
    }

    // 3. Security PIN creation required (new user)
    if (!authController.hasConfiguredPin) {
      if (route != null &&
          route.isNotEmpty &&
          route != '/create-pin' &&
          route != '/confirm-pin') {
        authController.intendedRoute = route;
      }
      return const RouteSettings(name: '/create-pin');
    }

    // 4. Returning user PIN verification required for active session
    if (!authController.isSessionUnlocked.value) {
      if (route != null &&
          route.isNotEmpty &&
          route != '/verify-pin' &&
          route != '/forgot-pin') {
        authController.intendedRoute = route;
      }
      return const RouteSettings(name: '/verify-pin');
    }

    // 5. Strict Role Separation: Admins cannot switch to customer dashboard
    if (authController.isAdmin.value &&
        (route == '/dashboard' || route == '/orders')) {
      return const RouteSettings(name: '/admin');
    }

    // Customer is fully authorized and session is unlocked
    return null;
  }
}

/// Strict route guard for the RESOLVA Admin Portal (`/admin`).
///
/// Only authenticated, PIN-verified Administrators (`isAdmin == true`) can access `/admin`.
/// Regular users attempting to navigate to `/admin` are blocked and redirected to `/dashboard`.
class AdminGuard extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final authController = Get.find<AuthController>();

    if (!authController.isLoggedIn.value) {
      authController.intendedRoute = '/admin';
      return const RouteSettings(name: '/login');
    }

    if (!authController.hasAcceptedCurrentPolicies) {
      authController.intendedRoute = '/admin';
      return const RouteSettings(name: '/policy-acceptance');
    }

    if (!authController.hasConfiguredPin) {
      authController.intendedRoute = '/admin';
      return const RouteSettings(name: '/create-pin');
    }

    if (!authController.isSessionUnlocked.value) {
      authController.intendedRoute = '/admin';
      return const RouteSettings(name: '/verify-pin');
    }

    // Block non-admin users from accessing the admin dashboard
    if (!authController.isAdmin.value) {
      return const RouteSettings(name: '/dashboard');
    }

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
