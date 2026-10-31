import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:resolva/main.dart';
import 'package:resolva/controllers/auth_controller.dart';
import 'package:resolva/controllers/onboarding_controller.dart';
import 'package:resolva/controllers/navigation_controller.dart';
import 'package:resolva/controllers/dashboard_controller.dart';
import 'package:resolva/controllers/exam_controller.dart';
import 'package:resolva/controllers/social_controller.dart';
import 'package:resolva/controllers/admin_controller.dart';

void main() {
  setUp(() {
    Get.reset();
    Get.put(NavigationController(), permanent: true);
    Get.put(AdminController(), permanent: true);
    Get.put(AuthController(), permanent: true);
    Get.put(OnboardingController(), permanent: true);
    Get.put(DashboardController(), permanent: true);
    Get.put(ExamController(), permanent: true);
    Get.put(SocialController(), permanent: true);
  });

  Future<void> testScreenAtSize(
    WidgetTester tester,
    Size size,
    String route,
  ) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(const ResolvaApp());
    Get.toNamed(route);
    await tester.pumpAndSettle();

    // Verify no red screen / crash or layout overflow
    expect(tester.takeException(), isNull);
  }

  group('Responsive Layouts — Small Phone (360x640)', () {
    const mobileSize = Size(360, 640);

    testWidgets('Renders Home Screen on mobile without overflow', (tester) async {
      await testScreenAtSize(tester, mobileSize, '/');
    });

    testWidgets('Renders Login / Register on mobile without overflow', (tester) async {
      await testScreenAtSize(tester, mobileSize, '/login');
      await testScreenAtSize(tester, mobileSize, '/register');
    });

    testWidgets('Renders Forgot Password on mobile without overflow', (tester) async {
      await testScreenAtSize(tester, mobileSize, '/forgot-password');
    });

    testWidgets('Renders Policy Acceptance on mobile without overflow', (tester) async {
      final auth = Get.find<AuthController>();
      auth.isLoggedIn.value = true;
      await testScreenAtSize(tester, mobileSize, '/policy-acceptance');
    });

    testWidgets('Renders Create PIN on mobile without overflow', (tester) async {
      final auth = Get.find<AuthController>();
      auth.isLoggedIn.value = true;
      auth.acceptPolicies();
      await testScreenAtSize(tester, mobileSize, '/create-pin');
    });

    testWidgets('Renders Confirm PIN on mobile without overflow', (tester) async {
      final auth = Get.find<AuthController>();
      auth.isLoggedIn.value = true;
      auth.acceptPolicies();
      await testScreenAtSize(tester, mobileSize, '/confirm-pin');
    });

    testWidgets('Renders Verify PIN on mobile without overflow', (tester) async {
      final auth = Get.find<AuthController>();
      auth.prepareDemoUser(isReturningUser: true);
      auth.isLoggedIn.value = true;
      await testScreenAtSize(tester, mobileSize, '/verify-pin');
    });

    testWidgets('Renders Terms and Privacy on mobile without overflow', (tester) async {
      await testScreenAtSize(tester, mobileSize, '/terms-of-service');
      await testScreenAtSize(tester, mobileSize, '/privacy-policy');
    });

    testWidgets('Renders About, Contact, FAQ on mobile without overflow', (tester) async {
      await testScreenAtSize(tester, mobileSize, '/about');
      await testScreenAtSize(tester, mobileSize, '/contact');
      await testScreenAtSize(tester, mobileSize, '/faq');
    });

    testWidgets('Renders Admin Dashboard on mobile (360x640) without overflow', (tester) async {
      final auth = Get.find<AuthController>();
      auth.prepareDemoUser(isReturningUser: true, isAdminUser: true);
      auth.isLoggedIn.value = true;
      auth.isSessionUnlocked.value = true;

      await testScreenAtSize(tester, mobileSize, '/admin');
    });

    testWidgets('Renders Admin Dashboard on ultra-compact mobile (320x568) without overflow', (tester) async {
      final auth = Get.find<AuthController>();
      auth.prepareDemoUser(isReturningUser: true, isAdminUser: true);
      auth.isLoggedIn.value = true;
      auth.isSessionUnlocked.value = true;

      await testScreenAtSize(tester, const Size(320, 568), '/admin');
    });
  });

  group('Strict Role-Based Security & Access Isolation', () {
    const desktopSize = Size(1440, 900);

    testWidgets('Customer is BLOCKED from /admin and redirected to /dashboard', (tester) async {
      final auth = Get.find<AuthController>();
      auth.prepareDemoUser(isReturningUser: true, isAdminUser: false);
      auth.isLoggedIn.value = true;
      auth.isSessionUnlocked.value = true;
      expect(auth.isAdmin.value, isFalse);

      tester.view.physicalSize = desktopSize;
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(const ResolvaApp());
      navigateTo('/admin');
      await tester.pumpAndSettle();

      // Verified: Attempting to visit /admin redirects customer to /dashboard
      expect(Get.currentRoute, equals('/dashboard'));
    });

    testWidgets('Admin is ISOLATED from /dashboard and redirected to /admin', (tester) async {
      final auth = Get.find<AuthController>();
      auth.prepareDemoUser(isReturningUser: true, isAdminUser: true);
      auth.isLoggedIn.value = true;
      auth.isSessionUnlocked.value = true;
      expect(auth.isAdmin.value, isTrue);

      tester.view.physicalSize = desktopSize;
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(const ResolvaApp());
      navigateTo('/dashboard');
      await tester.pumpAndSettle();

      // Verified: Attempting to visit /dashboard redirects admin to /admin
      expect(Get.currentRoute, equals('/admin'));
    });

    testWidgets('Unauthenticated user is BLOCKED from /admin and redirected to /login', (tester) async {
      final auth = Get.find<AuthController>();
      auth.isLoggedIn.value = false;
      auth.isSessionUnlocked.value = false;

      tester.view.physicalSize = desktopSize;
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(const ResolvaApp());
      Get.toNamed('/admin');
      await tester.pumpAndSettle();

      // Verified: Guest blocked and redirected to /login
      expect(Get.currentRoute, equals('/login'));
    });
  });

  group('Responsive Layouts — Large Desktop (1440x900)', () {
    const desktopSize = Size(1440, 900);

    testWidgets('Renders Home Screen on desktop', (tester) async {
      await testScreenAtSize(tester, desktopSize, '/');
    });

    testWidgets('Renders Protected Services for authorized user on desktop', (tester) async {
      final auth = Get.find<AuthController>();
      auth.prepareDemoUser(isReturningUser: true);
      auth.isLoggedIn.value = true;
      auth.isSessionUnlocked.value = true;

      await testScreenAtSize(tester, desktopSize, '/exam-pins');
      await testScreenAtSize(tester, desktopSize, '/social-media');
      await testScreenAtSize(tester, desktopSize, '/cac');
      await testScreenAtSize(tester, desktopSize, '/dashboard');
    });

    testWidgets('Renders Admin Dashboard for authorized admin on desktop', (tester) async {
      final auth = Get.find<AuthController>();
      auth.prepareDemoUser(isReturningUser: true, isAdminUser: true);
      auth.isLoggedIn.value = true;
      auth.isSessionUnlocked.value = true;

      await testScreenAtSize(tester, desktopSize, '/admin');
    });

    testWidgets('Supports physical keyboard input on Security PIN screens', (tester) async {
      final auth = Get.find<AuthController>();
      auth.prepareDemoUser(isReturningUser: true);
      auth.isLoggedIn.value = true;

      await testScreenAtSize(tester, desktopSize, '/verify-pin');

      // Type PIN 123456 using physical keyboard events
      await tester.sendKeyEvent(LogicalKeyboardKey.digit1);
      await tester.sendKeyEvent(LogicalKeyboardKey.digit2);
      await tester.sendKeyEvent(LogicalKeyboardKey.digit3);
      await tester.sendKeyEvent(LogicalKeyboardKey.backspace);
      await tester.sendKeyEvent(LogicalKeyboardKey.digit3);
      await tester.sendKeyEvent(LogicalKeyboardKey.digit4);
      await tester.sendKeyEvent(LogicalKeyboardKey.digit5);
      await tester.sendKeyEvent(LogicalKeyboardKey.digit6);
      await tester.pumpAndSettle();

      // Verify PIN was accepted and session unlocked
      expect(auth.isSessionUnlocked.value, isTrue);
    });
  });
}
