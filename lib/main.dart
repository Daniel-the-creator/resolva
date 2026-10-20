import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/theme/app_theme.dart';
import 'core/guards/auth_guard.dart';
import 'controllers/navigation_controller.dart';
import 'controllers/auth_controller.dart';
import 'controllers/onboarding_controller.dart';
import 'controllers/dashboard_controller.dart';
import 'controllers/exam_controller.dart';
import 'controllers/social_controller.dart';
import 'screens/home/home_screen.dart';
import 'screens/exam/exam_pins_screen.dart';
import 'screens/social/social_media_screen.dart';
import 'screens/cac/cac_screen.dart';
import 'screens/dashboard/dashboard_screen.dart';
import 'screens/auth/auth_screen.dart';
import 'screens/auth/forgot_password_screen.dart';
import 'screens/onboarding/policy_acceptance_screen.dart';
import 'screens/onboarding/create_pin_screen.dart';
import 'screens/onboarding/confirm_pin_screen.dart';
import 'screens/onboarding/verify_pin_screen.dart';
import 'screens/onboarding/forgot_pin_screen.dart';
import 'screens/legal/legal_screens.dart';
import 'screens/info/info_screens.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ResolvaApp());
}

/// Global navigation helper
void navigateTo(String route) {
  final navController = Get.find<NavigationController>();

  switch (route) {
    case '/':
      navController.changePage(0);
      break;
    case '/exam-pins':
      navController.changePage(1);
      break;
    case '/social-media':
      navController.changePage(2);
      break;
    case '/cac':
      navController.changePage(3);
      break;
    case '/dashboard':
      navController.changePage(4);
      break;
    default:
      navController.changePage(-1);
      break;
  }

  if (Get.currentRoute != route) {
    Get.toNamed(route);
  }
}

class ResolvaApp extends StatelessWidget {
  const ResolvaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'RESOLVA — Digital Services Platform',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialBinding: InitialBinding(),
      initialRoute: '/',
      defaultTransition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 200),
      getPages: [
        // ──────────────── PUBLIC ROUTES ────────────────
        GetPage(
          name: '/',
          page: () => const HomeScreen(onNavigate: navigateTo),
        ),
        GetPage(
          name: '/login',
          page: () => const AuthScreen(onNavigate: navigateTo, initialRegister: false),
        ),
        GetPage(
          name: '/register',
          page: () => const AuthScreen(onNavigate: navigateTo, initialRegister: true),
        ),
        GetPage(
          name: '/forgot-password',
          page: () => const ForgotPasswordScreen(onNavigate: navigateTo),
        ),
        GetPage(
          name: '/about',
          page: () => const AboutScreen(onNavigate: navigateTo),
        ),
        GetPage(
          name: '/contact',
          page: () => const ContactScreen(onNavigate: navigateTo),
        ),
        GetPage(
          name: '/faq',
          page: () => const FaqScreen(onNavigate: navigateTo),
        ),
        GetPage(
          name: '/terms-of-service',
          page: () => const TermsOfServiceScreen(onNavigate: navigateTo),
        ),
        GetPage(
          name: '/privacy-policy',
          page: () => const PrivacyPolicyScreen(onNavigate: navigateTo),
        ),

        // ──────────────── ONBOARDING & PIN ROUTES (GUARDED) ────────────────
        GetPage(
          name: '/policy-acceptance',
          page: () => const PolicyAcceptanceScreen(onNavigate: navigateTo),
          middlewares: [OnboardingGuard()],
        ),
        GetPage(
          name: '/create-pin',
          page: () => const CreatePinScreen(onNavigate: navigateTo),
          middlewares: [OnboardingGuard()],
        ),
        GetPage(
          name: '/confirm-pin',
          page: () => const ConfirmPinScreen(onNavigate: navigateTo),
          middlewares: [OnboardingGuard()],
        ),
        GetPage(
          name: '/verify-pin',
          page: () => const VerifyPinScreen(onNavigate: navigateTo),
          middlewares: [OnboardingGuard()],
        ),
        GetPage(
          name: '/forgot-pin',
          page: () => const ForgotPinScreen(onNavigate: navigateTo),
          middlewares: [OnboardingGuard()],
        ),

        // ──────────────── PROTECTED SERVICE & USER ROUTES ────────────────
        GetPage(
          name: '/exam-pins',
          page: () => const ExamPinsScreen(onNavigate: navigateTo),
          middlewares: [AuthGuard()],
        ),
        GetPage(
          name: '/social-media',
          page: () => const SocialMediaScreen(onNavigate: navigateTo),
          middlewares: [AuthGuard()],
        ),
        GetPage(
          name: '/cac',
          page: () => const CacScreen(onNavigate: navigateTo),
          middlewares: [AuthGuard()],
        ),
        GetPage(
          name: '/dashboard',
          page: () => const DashboardScreen(onNavigate: navigateTo, initialTab: 0),
          middlewares: [AuthGuard()],
        ),
        GetPage(
          name: '/orders',
          page: () => const DashboardScreen(onNavigate: navigateTo, initialTab: 1),
          middlewares: [AuthGuard()],
        ),
      ],
    );
  }
}

/// Initial dependency bindings for GetX
class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(NavigationController(), permanent: true);
    Get.put(AuthController(), permanent: true);
    Get.put(OnboardingController(), permanent: true);
    Get.put(DashboardController(), permanent: true);
    Get.put(ExamController(), permanent: true);
    Get.put(SocialController(), permanent: true);
  }
}
