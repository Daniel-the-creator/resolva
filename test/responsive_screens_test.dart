import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:resolva/main.dart';
import 'package:resolva/controllers/auth_controller.dart';
import 'package:resolva/controllers/onboarding_controller.dart';
import 'package:resolva/controllers/navigation_controller.dart';
import 'package:resolva/controllers/dashboard_controller.dart';
import 'package:resolva/controllers/exam_controller.dart';
import 'package:resolva/controllers/social_controller.dart';

void main() {
  setUp(() {
    Get.reset();
    Get.put(NavigationController(), permanent: true);
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
  });
}
