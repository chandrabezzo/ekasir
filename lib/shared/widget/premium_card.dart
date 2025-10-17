import 'package:flutter/material.dart';
import '../../app/constant/app_colors.dart';

/// A premium card widget with customizable elevation, gradient, and border
class PremiumCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? elevation;
  final Color? color;
  final Gradient? gradient;
  final BorderRadius? borderRadius;
  final Border? border;
  final VoidCallback? onTap;
  final List<BoxShadow>? boxShadow;

  const PremiumCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.elevation,
    this.color,
    this.gradient,
    this.borderRadius,
    this.border,
    this.onTap,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    final defaultBorderRadius = borderRadius ?? BorderRadius.circular(16);

    Widget content = Container(
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: gradient == null ? (color ?? AppColors.white) : null,
        gradient: gradient,
        borderRadius: defaultBorderRadius,
        border: border,
        boxShadow: boxShadow ??
            [
              BoxShadow(
                color: AppColors.black.withValues(alpha: 0.08),
                blurRadius: elevation ?? 8,
                offset: const Offset(0, 2),
              ),
            ],
      ),
      child: child,
    );

    if (onTap != null) {
      content = Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: defaultBorderRadius,
          child: content,
        ),
      );
    }

    return Container(
      margin: margin ?? EdgeInsets.zero,
      child: content,
    );
  }
}
