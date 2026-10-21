import 'package:get/get.dart';
import '../core/constants/app_constants.dart';

/// Central authentication and session authorization controller.
///
/// NOTE: This implementation is for frontend demonstration only.
/// In production, real authentication tokens, server-side authorization,
/// and secure biometric / hardware-backed PIN verifications must be enforced.
class AuthController extends GetxController {
  // Login form state
  final loginEmail = ''.obs;
  final loginPassword = ''.obs;
  final rememberMe = false.obs;
  final loginLoading = false.obs;
  final loginPasswordVisible = false.obs;

  // Registration form state
  final regFullName = ''.obs;
  final regEmail = ''.obs;
  final regPhone = ''.obs;
  final regPassword = ''.obs;
  final regConfirmPassword = ''.obs;
  final regAcceptTerms = false.obs;
  final regLoading = false.obs;
  final regPasswordVisible = false.obs;
  final regConfirmPasswordVisible = false.obs;

  // Authentication & session state
  final isLoggedIn = false.obs;
  final isSessionUnlocked = false.obs;
  final showRegistration = false.obs;

  // Legal policy acceptance tracking (versioned)
  final acceptedTermsVersion = ''.obs;
  final acceptedPrivacyVersion = ''.obs;

  // Security PIN setup (6 digits)
  final securityPin = ''.obs;

  // Redirect destination after completing auth/onboarding (internal state, non-observable)
  String intendedRoute = '';

  // Registered user demo profile
  final userFullName = 'Demo User'.obs;
  final userEmail = 'demo@resolva.ng'.obs;

  // Helper getters
  bool get hasAcceptedCurrentPolicies =>
      acceptedTermsVersion.value == AppConstants.termsVersion &&
      acceptedPrivacyVersion.value == AppConstants.privacyVersion;

  bool get hasConfiguredPin =>
      securityPin.value.isNotEmpty && securityPin.value.length == 6;

  bool get isFullyAuthorized =>
      isLoggedIn.value &&
      hasAcceptedCurrentPolicies &&
      hasConfiguredPin &&
      isSessionUnlocked.value;

  /// Returns the next route the user should visit based on their onboarding state.
  String getNextAuthRoute() {
    if (!isLoggedIn.value) {
      return '/login';
    }
    if (!hasAcceptedCurrentPolicies) {
      return '/policy-acceptance';
    }
    if (!hasConfiguredPin) {
      return '/create-pin';
    }
    if (!isSessionUnlocked.value) {
      return '/verify-pin';
    }
    final target = intendedRoute.isNotEmpty ? intendedRoute : '/dashboard';
    intendedRoute = '';
    return target;
  }

  void toggleAuthForm() {
    showRegistration.value = !showRegistration.value;
  }

  void toggleLoginPasswordVisibility() {
    loginPasswordVisible.value = !loginPasswordVisible.value;
  }

  void toggleRegPasswordVisibility() {
    regPasswordVisible.value = !regPasswordVisible.value;
  }

  void toggleRegConfirmPasswordVisibility() {
    regConfirmPasswordVisible.value = !regConfirmPasswordVisible.value;
  }

  /// Sets up credentials for demonstration testing.
  /// If [isReturningUser] is true, configures terms acceptance and existing PIN '123456'.
  /// If false, creates a new un-onboarded user who must accept terms and create a PIN.
  void prepareDemoUser({required bool isReturningUser}) {
    loginEmail.value = 'demo@resolva.ng';
    loginPassword.value = 'ResolvaPass2025!';
    userFullName.value = 'Demo User';
    userEmail.value = 'demo@resolva.ng';

    if (isReturningUser) {
      acceptedTermsVersion.value = AppConstants.termsVersion;
      acceptedPrivacyVersion.value = AppConstants.privacyVersion;
      securityPin.value = '123456';
      isSessionUnlocked.value = false;
    } else {
      acceptedTermsVersion.value = '';
      acceptedPrivacyVersion.value = '';
      securityPin.value = '';
      isSessionUnlocked.value = false;
    }
  }

  /// Simulates a login (frontend demo only).
  Future<bool> login() async {
    if (loginEmail.value.isEmpty || loginPassword.value.isEmpty) return false;
    loginLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 600));
    loginLoading.value = false;
    isLoggedIn.value = true;
    isSessionUnlocked.value = false; // session requires PIN verification if returning
    userEmail.value = loginEmail.value;
    return true;
  }

  /// Simulates registration (frontend demo only).
  Future<bool> register() async {
    if (regFullName.value.isEmpty ||
        regEmail.value.isEmpty ||
        regPhone.value.isEmpty ||
        regPassword.value.isEmpty ||
        regPassword.value != regConfirmPassword.value ||
        !regAcceptTerms.value) {
      return false;
    }
    regLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 600));
    regLoading.value = false;
    isLoggedIn.value = true;
    isSessionUnlocked.value = false;
    userFullName.value = regFullName.value;
    userEmail.value = regEmail.value;

    // A newly registered user has not completed policy acceptance or PIN setup
    acceptedTermsVersion.value = '';
    acceptedPrivacyVersion.value = '';
    securityPin.value = '';

    return true;
  }

  /// Marks terms and privacy policy as accepted for the current versions.
  void acceptPolicies() {
    acceptedTermsVersion.value = AppConstants.termsVersion;
    acceptedPrivacyVersion.value = AppConstants.privacyVersion;
  }

  /// Configures a new 6-digit security PIN and unlocks the active session.
  void setSecurityPin(String pin) {
    if (pin.length == 6) {
      securityPin.value = pin;
      isSessionUnlocked.value = true;
    }
  }

  /// Verifies entered PIN against stored demonstration PIN.
  bool verifyPin(String enteredPin) {
    final valid = enteredPin == securityPin.value;
    if (valid) {
      isSessionUnlocked.value = true;
    }
    return valid;
  }

  /// Resets user PIN during forgot-pin recovery.
  void resetPinForDemo() {
    securityPin.value = '';
    isSessionUnlocked.value = false;
  }

  /// Standard logout: clears active session and authentication,
  /// preserving stored PIN and policy acceptance for demonstration returning-user flow.
  void logout() {
    isLoggedIn.value = false;
    isSessionUnlocked.value = false;
    intendedRoute = '';
    loginPassword.value = '';
  }
}
