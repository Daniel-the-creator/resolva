import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';

/// Six-digit masked PIN indicators.
class PinIndicators extends StatelessWidget {
  final int length;
  final int totalDigits;
  final bool hasError;

  const PinIndicators({
    super.key,
    required this.length,
    this.totalDigits = 6,
    this.hasError = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalDigits, (index) {
        final isFilled = index < length;
        final isCurrent = index == length;

        Color borderColor;
        Color fillColor;

        if (hasError) {
          borderColor = AppColors.error;
          fillColor = AppColors.error.withValues(alpha: 0.15);
        } else if (isFilled) {
          borderColor = AppColors.royalBlue;
          fillColor = AppColors.royalBlue;
        } else if (isCurrent) {
          borderColor = AppColors.royalBlue;
          fillColor = Colors.transparent;
        } else {
          borderColor = AppColors.cardBorder;
          fillColor = AppColors.cardBackground;
        }

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: fillColor,
            border: Border.all(
              color: borderColor,
              width: isFilled || isCurrent || hasError ? 2 : 1.5,
            ),
            boxShadow: isFilled
                ? [
                    BoxShadow(
                      color: AppColors.royalBlue.withValues(alpha: 0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
        );
      }),
    );
  }
}

/// Custom responsive on-screen numeric keypad for Security PIN entry.
class NumericKeypad extends StatelessWidget {
  final Function(String) onDigitPressed;
  final VoidCallback onDeletePressed;
  final VoidCallback onClearPressed;

  const NumericKeypad({
    super.key,
    required this.onDigitPressed,
    required this.onDeletePressed,
    required this.onClearPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 320),
      child: Column(
        children: [
          _buildRow(['1', '2', '3']),
          const SizedBox(height: 14),
          _buildRow(['4', '5', '6']),
          const SizedBox(height: 14),
          _buildRow(['7', '8', '9']),
          const SizedBox(height: 14),
          _buildBottomRow(),
        ],
      ),
    );
  }

  Widget _buildRow(List<String> digits) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: digits.map((d) => _buildDigitButton(d)).toList(),
    );
  }

  Widget _buildBottomRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Clear button
        _buildActionButton(
          label: 'Clear',
          icon: null,
          onTap: onClearPressed,
          tooltip: 'Clear all digits',
        ),
        // 0 digit
        _buildDigitButton('0'),
        // Backspace button
        _buildActionButton(
          label: null,
          icon: Icons.backspace_outlined,
          onTap: onDeletePressed,
          tooltip: 'Delete digit',
        ),
      ],
    );
  }

  Widget _buildDigitButton(String digit) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onDigitPressed(digit),
        borderRadius: BorderRadius.circular(16),
        hoverColor: AppColors.royalBlue.withValues(alpha: 0.08),
        splashColor: AppColors.royalBlue.withValues(alpha: 0.15),
        child: Container(
          width: 76,
          height: 64,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.cardBorder, width: 1.2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            digit,
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryNavy,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String? label,
    required IconData? icon,
    required VoidCallback onTap,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          hoverColor: AppColors.royalBlue.withValues(alpha: 0.08),
          splashColor: AppColors.royalBlue.withValues(alpha: 0.15),
          child: Container(
            width: 76,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.cardBorder, width: 1.2),
            ),
            alignment: Alignment.center,
            child: icon != null
                ? Icon(icon, color: AppColors.textSecondary, size: 22)
                : Text(
                    label ?? '',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
