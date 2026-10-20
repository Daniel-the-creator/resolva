import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../controllers/onboarding_controller.dart';
import '../../widgets/shared/numeric_keypad.dart';

/// Step 1 of Security PIN setup: Enter the initial 6-digit PIN.
class CreatePinScreen extends StatefulWidget {
  final Function(String) onNavigate;

  const CreatePinScreen({super.key, required this.onNavigate});

  @override
  State<CreatePinScreen> createState() => _CreatePinScreenState();
}

class _CreatePinScreenState extends State<CreatePinScreen> {
  late final OnboardingController onboardingController;

  @override
  void initState() {
    super.initState();
    onboardingController = Get.find<OnboardingController>();
    onboardingController.resetAll();
  }

  void _handleContinue() {
    if (onboardingController.pinInput.value.length == 6) {
      onboardingController.tempCreatedPin.value = onboardingController.pinInput.value;
      onboardingController.pinInput.value = '';
      widget.onNavigate('/confirm-pin');
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
                      'Create Your Security PIN',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: isMobile ? 22 : 24,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primaryNavy,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Create a secure PIN to protect access to your RESOLVA services.',
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

                    // Inline error text (if any)
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
                      onDigitPressed: onboardingController.appendDigit,
                      onDeletePressed: onboardingController.deleteDigit,
                      onClearPressed: onboardingController.clearDigits,
                    ),
                    const SizedBox(height: 28),

                    // Continue button (only active when 6 digits entered)
                    Obx(() {
                      final isComplete = onboardingController.pinInput.value.length == 6;
                      return SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: isComplete ? _handleContinue : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.royalBlue,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            disabledBackgroundColor: AppColors.cardBorder,
                          ),
                          child: Text(
                            'Continue',
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      );
                    }),
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
