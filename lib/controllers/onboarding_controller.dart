import 'package:get/get.dart';

/// Controller managing numeric keypad inputs, temporary PIN states,
/// confirmation validation, and recovery simulations during onboarding.
class OnboardingController extends GetxController {
  // Current 6-digit PIN input entered on keypad
  final pinInput = ''.obs;

  // Stored PIN from step 1 (Create PIN) to compare during step 2 (Confirm PIN)
  final tempCreatedPin = ''.obs;

  // Inline error message for mismatched or invalid PIN entries
  final errorMessage = ''.obs;

  // Keypad processing indicator
  final isProcessing = false.obs;

  // Demo recovery code for forgot-pin flow
  final recoveryEmail = ''.obs;
  final demoRecoveryCode = '849201'.obs;
  final enteredRecoveryCode = ''.obs;
  final recoveryStep = 0.obs; // 0: enter email, 1: enter code

  void appendDigit(String digit) {
    if (pinInput.value.length < 6) {
      errorMessage.value = '';
      pinInput.value += digit;
    }
  }

  void deleteDigit() {
    if (pinInput.value.isNotEmpty) {
      errorMessage.value = '';
      pinInput.value = pinInput.value.substring(0, pinInput.value.length - 1);
    }
  }

  void clearDigits() {
    errorMessage.value = '';
    pinInput.value = '';
  }

  void resetAll() {
    pinInput.value = '';
    tempCreatedPin.value = '';
    errorMessage.value = '';
    isProcessing.value = false;
    recoveryStep.value = 0;
    enteredRecoveryCode.value = '';
  }

  void setErrorMessage(String msg) {
    errorMessage.value = msg;
  }
}
