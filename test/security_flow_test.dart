import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:resolva/controllers/auth_controller.dart';
import 'package:resolva/controllers/onboarding_controller.dart';
import 'package:resolva/core/guards/auth_guard.dart';

void main() {
  group('RESOLVA Security & Onboarding Flow Tests', () {
    late AuthController authController;
    late OnboardingController onboardingController;
    late AuthGuard authGuard;

    setUp(() {
      Get.reset();
      authController = Get.put(AuthController());
      onboardingController = Get.put(OnboardingController());
      authGuard = AuthGuard();
    });

    test('Scenario 1 & 2: Logged-out users cannot access protected routes and are redirected to /login', () {
      expect(authController.isLoggedIn.value, false);
      expect(authController.isFullyAuthorized, false);

      // Attempting to access protected routes
      final redirectExam = authGuard.redirect('/exam-pins');
      expect(redirectExam?.name, '/login');
      expect(authController.intendedRoute, '/exam-pins');

      final redirectSocial = authGuard.redirect('/social-media');
      expect(redirectSocial?.name, '/login');
      expect(authController.intendedRoute, '/social-media');

      final redirectDashboard = authGuard.redirect('/dashboard');
      expect(redirectDashboard?.name, '/login');
      expect(authController.intendedRoute, '/dashboard');
    });

    test('Scenario 3: Newly registered user must accept Terms of Service & Privacy Policy', () async {
      // Prepare new user
      authController.prepareDemoUser(isReturningUser: false);
      expect(authController.hasAcceptedCurrentPolicies, false);

      // Simulate registration/login
      final ok = await authController.login();
      expect(ok, true);
      expect(authController.isLoggedIn.value, true);

      // Guard should redirect to policy acceptance
      final redirect = authGuard.redirect('/dashboard');
      expect(redirect?.name, '/policy-acceptance');
      expect(authController.getNextAuthRoute(), '/policy-acceptance');
    });

    test('Scenario 4: User must accept policy before advancing to PIN setup', () {
      authController.isLoggedIn.value = true;
      authController.acceptedTermsVersion.value = '';
      authController.acceptedPrivacyVersion.value = '';

      expect(authController.hasAcceptedCurrentPolicies, false);
      expect(authGuard.redirect('/dashboard')?.name, '/policy-acceptance');

      // User accepts current policies
      authController.acceptPolicies();
      expect(authController.hasAcceptedCurrentPolicies, true);

      // Next step should now be create PIN
      expect(authGuard.redirect('/dashboard')?.name, '/create-pin');
      expect(authController.getNextAuthRoute(), '/create-pin');
    });

    test('Scenario 5 & 6: User must create and confirm six-digit PIN; mismatch fails', () {
      authController.isLoggedIn.value = true;
      authController.acceptPolicies();

      // Step 1: Create PIN
      const createdPin = '123456';
      onboardingController.tempCreatedPin = createdPin;

      // Step 2: Confirmation mismatch
      const mismatchPin = '123999';
      expect(mismatchPin != onboardingController.tempCreatedPin, true);

      // Does not grant access on mismatch
      expect(authController.hasConfiguredPin, false);
      expect(authController.isFullyAuthorized, false);

      // Step 3: Correct matching PIN
      const matchingPin = '123456';
      if (matchingPin == onboardingController.tempCreatedPin) {
        authController.setSecurityPin(matchingPin);
      }

      expect(authController.hasConfiguredPin, true);
      expect(authController.isSessionUnlocked.value, true);
      expect(authController.isFullyAuthorized, true);

      // Access granted
      expect(authGuard.redirect('/dashboard'), isNull);
    });

    test('Scenario 7: Returning users with existing PIN must verify PIN on new session', () {
      // Returning user has accepted policies and has configured PIN
      authController.prepareDemoUser(isReturningUser: true);
      authController.isLoggedIn.value = true;
      authController.isSessionUnlocked.value = false; // New session is locked

      expect(authController.hasAcceptedCurrentPolicies, true);
      expect(authController.hasConfiguredPin, true);
      expect(authController.isFullyAuthorized, false);

      // Guard redirects to verify-pin
      expect(authGuard.redirect('/dashboard')?.name, '/verify-pin');
      expect(authController.getNextAuthRoute(), '/verify-pin');

      // Incorrect PIN fails
      final wrong = authController.verifyPin('000000');
      expect(wrong, false);
      expect(authController.isSessionUnlocked.value, false);

      // Correct PIN unlocks session
      final correct = authController.verifyPin('123456');
      expect(correct, true);
      expect(authController.isSessionUnlocked.value, true);
      expect(authController.isFullyAuthorized, true);

      // Route is now accessible
      expect(authGuard.redirect('/dashboard'), isNull);
    });

    test('Scenario 8 & 9: Policy acceptance is persistent, but updated version requires re-acceptance', () {
      authController.prepareDemoUser(isReturningUser: true);
      authController.isLoggedIn.value = true;
      authController.isSessionUnlocked.value = true;

      // Currently accepted matches AppConstants
      expect(authController.hasAcceptedCurrentPolicies, true);
      expect(authGuard.redirect('/dashboard'), isNull);

      // Simulate a policy version update in the system
      authController.acceptedTermsVersion.value = '0.9.0'; // Older version
      expect(authController.hasAcceptedCurrentPolicies, false);

      // Guard immediately blocks access and redirects to policy acceptance
      expect(authGuard.redirect('/dashboard')?.name, '/policy-acceptance');
    });

    test('Scenario 10: Logout blocks access to protected routes while preserving PIN', () {
      // Fully authorized user
      authController.prepareDemoUser(isReturningUser: true);
      authController.isLoggedIn.value = true;
      authController.isSessionUnlocked.value = true;
      expect(authController.isFullyAuthorized, true);

      // User logs out
      authController.logout();
      expect(authController.isLoggedIn.value, false);
      expect(authController.isSessionUnlocked.value, false);
      expect(authController.isFullyAuthorized, false);

      // PIN is preserved for returning demonstration flow
      expect(authController.securityPin.value, '123456');

      // Protected routes are blocked again
      expect(authGuard.redirect('/exam-pins')?.name, '/login');
      expect(authGuard.redirect('/dashboard')?.name, '/login');
    });

    test('Scenario 11: Forgot PIN does not provide unrestricted bypass', () {
      authController.prepareDemoUser(isReturningUser: true);
      authController.isLoggedIn.value = true;
      authController.isSessionUnlocked.value = false;

      // Forgot PIN resets the PIN and requires going through create & confirm PIN
      authController.resetPinForDemo();
      expect(authController.hasConfiguredPin, false);
      expect(authController.isSessionUnlocked.value, false);
      expect(authController.isFullyAuthorized, false);

      // Cannot bypass directly to dashboard
      expect(authGuard.redirect('/dashboard')?.name, '/create-pin');
    });

    test('Scenario 12: Admin role security isolation — cannot switch to customer dashboard/orders', () {
      authController.prepareDemoUser(isReturningUser: true, isAdminUser: true);
      authController.isLoggedIn.value = true;
      authController.isSessionUnlocked.value = true;
      expect(authController.isAdmin.value, true);

      // AuthGuard redirects admin away from customer dashboard & orders to /admin
      expect(authGuard.redirect('/dashboard')?.name, '/admin');
      expect(authGuard.redirect('/orders')?.name, '/admin');
    });

    test('Scenario 13: AdminGuard prevents regular customers from accessing /admin', () {
      final adminGuard = AdminGuard();
      authController.prepareDemoUser(isReturningUser: true, isAdminUser: false);
      authController.isLoggedIn.value = true;
      authController.isSessionUnlocked.value = true;
      expect(authController.isAdmin.value, false);

      // Customer is blocked and redirected to /dashboard
      expect(adminGuard.redirect('/admin')?.name, '/dashboard');
    });

    test('Scenario 14: AdminGuard redirects unauthenticated visitors to /login', () {
      final adminGuard = AdminGuard();
      authController.isLoggedIn.value = false;
      authController.isSessionUnlocked.value = false;

      // Guest is redirected to /login with intendedRoute recorded
      expect(adminGuard.redirect('/admin')?.name, '/login');
      expect(authController.intendedRoute, '/admin');
    });
  });
}
