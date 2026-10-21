import 'package:get/get.dart';

/// Controller managing multi-step onboarding states across screens.
class OnboardingController extends GetxController {
  // Stored PIN from step 1 (Create PIN) to compare during step 2 (Confirm PIN)
  String tempCreatedPin = '';

  // Demo recovery code for forgot-pin flow
  final demoRecoveryCode = '849201';

  void resetAll() {
    tempCreatedPin = '';
  }
}
