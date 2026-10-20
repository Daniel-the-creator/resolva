import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:resolva/controllers/auth_controller.dart';
import 'package:resolva/controllers/onboarding_controller.dart';
import 'package:resolva/core/guards/auth_guard.dart';
import 'package:resolva/core/constants/app_constants.dart';

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
      expect(authController.intendedRoute.value, '/exam-pins');

      final redirectSocial = authGuard.redirect('/social-media');
      expect(redirectSocial?.name, '/login');
      expect(authController.intendedRoute.value, '/social-media');

      final redirectDashboard = authGuard.redirect('/dashboard');
      expect(redirectDashboard?.name, '/login');
      expect(authController.intendedRoute.value, '/dashboard');
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
      onboardingController.appendDigit('1');
      onboardingController.appendDigit('2');
      onboardingController.appendDigit('3');
      onboardingController.appendDigit('4');
      onboardingController.appendDigit('5');
      onboardingController.appendDigit('6');
      expect(onboardingController.pinInput.value, '123456');

      // Save as temporary created PIN
      onboardingController.tempCreatedPin.value = onboardingController.pinInput.value;
      onboardingController.clearDigits();

      // Step 2: Confirmation mismatch
      onboardingController.appendDigit('1');
      onboardingController.appendDigit('2');
      onboardingController.appendDigit('3');
      onboardingController.appendDigit('9');
      onboardingController.appendDigit('9');
      onboardingController.appendDigit('9');
      expect(onboardingController.pinInput.value != onboardingController.tempCreatedPin.value, true);

      // Does not grant access on mismatch
      expect(authController.hasConfiguredPin, false);
      expect(authController.isFullyAuthorized, false);

      // Step 3: Correct matching PIN
      onboardingController.clearDigits();
      onboardingController.appendDigit('1');
      onboardingController.appendDigit('2');
      onboardingController.appendDigit('3');
      onboardingController.appendDigit('4');
      onboardingController.appendDigit('5');
      onboardingController.appendDigit('6');

      if (onboardingController.pinInput.value == onboardingController.tempCreatedPin.value) {
        authController.setSecurityPin(onboardingController.pinInput.value);
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
  });
}
