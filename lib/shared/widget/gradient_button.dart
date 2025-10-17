import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../app/constant/app_colors.dart';

/// A premium gradient button with loading state and haptic feedback
class GradientButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Gradient? gradient;
  final Color? color;
  final bool isLoading;
  final double? width;
  final double height;
  final BorderRadius? borderRadius;
  final bool enableHaptic;

  const GradientButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.gradient,
    this.color,
    this.isLoading = false,
    this.width,
    this.height = 52,
    this.borderRadius,
    this.enableHaptic = true,
  });

  @override
  Widget build(BuildContext context) {
    final defaultBorderRadius = borderRadius ?? BorderRadius.circular(12);
    final isEnabled = onPressed != null && !isLoading;

    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: Material(
        elevation: isEnabled ? 4 : 0,
        borderRadius: defaultBorderRadius,
        color: Colors.transparent,
        child: Ink(
          decoration: BoxDecoration(
            gradient: isEnabled
                ? (gradient ?? AppColors.purpleGradient)
                : null,
            color: isEnabled ? null : AppColors.gray300,
            borderRadius: defaultBorderRadius,
          ),
          child: InkWell(
            onTap: isEnabled
                ? () {
                    if (enableHaptic) {
                      HapticFeedback.mediumImpact();
                    }
                    onPressed?.call();
                  }
                : null,
            borderRadius: defaultBorderRadius,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: isLoading
                  ? const Center(
                      child: SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(AppColors.white),
                        ),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (icon != null) ...[
                          Icon(icon, color: AppColors.white, size: 22),
                          const SizedBox(width: 10),
                        ],
                        Text(
                          label,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.white,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
