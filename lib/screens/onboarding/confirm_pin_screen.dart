import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/onboarding_controller.dart';
import '../../widgets/shared/numeric_keypad.dart';

/// Step 2 of Security PIN setup: Re-enter and verify the 6-digit PIN.
class ConfirmPinScreen extends StatefulWidget {
  final Function(String) onNavigate;

  const ConfirmPinScreen({super.key, required this.onNavigate});

  @override
  State<ConfirmPinScreen> createState() => _ConfirmPinScreenState();
}

class _ConfirmPinScreenState extends State<ConfirmPinScreen> {
  late final AuthController authController;
  late final OnboardingController onboardingController;

  @override
  void initState() {
    super.initState();
    authController = Get.find<AuthController>();
    onboardingController = Get.find<OnboardingController>();
    onboardingController.pinInput.value = '';
    onboardingController.errorMessage.value = '';
  }

  void _handleConfirm() async {
    final entered = onboardingController.pinInput.value;
    final expected = onboardingController.tempCreatedPin.value;

    if (entered.length != 6) return;

    if (entered == expected) {
      // PIN Setup Successful!
      authController.setSecurityPin(entered);
      onboardingController.resetAll();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Security PIN successfully configured!'),
          backgroundColor: AppColors.emeraldGreen,
          duration: Duration(seconds: 2),
        ),
      );

      // Navigate to originally requested service or dashboard
      final destination = authController.intendedRoute.value.isNotEmpty
          ? authController.intendedRoute.value
          : '/dashboard';
      authController.intendedRoute.value = '';
      widget.onNavigate(destination);
    } else {
      // Mismatch
      onboardingController.setErrorMessage('PINs do not match. Please try again.');
      onboardingController.pinInput.value = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 700;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: 24,
              vertical: isMobile ? 24 : 40,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Container(
                padding: EdgeInsets.all(isMobile ? 24 : 36),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.cardBorder),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Brand Logo
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Center(
                        child: Text(
                          'R',
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Headings
                    Text(
                      'Confirm Your Security PIN',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: isMobile ? 22 : 24,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primaryNavy,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Re-enter your six-digit PIN to confirm it matches.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Six-digit masked indicators
                    Obx(
                      () => PinIndicators(
                        length: onboardingController.pinInput.value.length,
                        hasError: onboardingController.errorMessage.value.isNotEmpty,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Inline error text
                    Obx(() {
                      if (onboardingController.errorMessage.value.isEmpty) {
                        return const SizedBox(height: 18);
                      }
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Text(
                          onboardingController.errorMessage.value,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.error,
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 8),

                    // Numeric Keypad
                    NumericKeypad(
                      onDigitPressed: (d) {
                        onboardingController.appendDigit(d);
                        if (onboardingController.pinInput.value.length == 6) {
                          _handleConfirm();
                        }
                      },
                      onDeletePressed: onboardingController.deleteDigit,
                      onClearPressed: onboardingController.clearDigits,
                    ),
                    const SizedBox(height: 28),

                    // Confirm button
                    Obx(() {
                      final isComplete = onboardingController.pinInput.value.length == 6;
                      return SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: isComplete ? _handleConfirm : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.royalBlue,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            disabledBackgroundColor: AppColors.cardBorder,
                          ),
                          child: Text(
                            'Confirm Security PIN',
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 12),

                    // Back / Change PIN option
                    TextButton(
                      onPressed: () => widget.onNavigate('/create-pin'),
                      child: Text(
                        'Change Original PIN',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
