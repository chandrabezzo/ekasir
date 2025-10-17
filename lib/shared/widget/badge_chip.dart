import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../app/constant/app_colors.dart';

/// A premium badge/chip widget for status, counts, and labels
class BadgeChip extends StatelessWidget {
  final String label;
  final Color? color;
  final Color? backgroundColor;
  final IconData? icon;
  final bool outlined;
  final EdgeInsetsGeometry? padding;

  const BadgeChip({
    super.key,
    required this.label,
    this.color,
    this.backgroundColor,
    this.icon,
    this.outlined = false,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? AppColors.primary;
    final effectiveBgColor =
        backgroundColor ?? effectiveColor.withValues(alpha: 0.12);

    return Container(
      padding: padding ??
          const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: outlined ? Colors.transparent : effectiveBgColor,
        border: outlined
            ? Border.all(color: effectiveColor, width: 1.5)
            : null,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: effectiveColor),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: effectiveColor,
            ),
          ),
        ],
      ),
    );
  }
}

/// Preset badges for common statuses
class StatusBadge extends StatelessWidget {
  final String label;
  final StatusType type;

  const StatusBadge({
    super.key,
    required this.label,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    Color color;
    IconData? icon;

    switch (type) {
      case StatusType.success:
        color = AppColors.success;
        icon = Icons.check_circle;
        break;
      case StatusType.error:
        color = AppColors.error;
        icon = Icons.cancel;
        break;
      case StatusType.warning:
        color = AppColors.warning;
        icon = Icons.warning;
        break;
      case StatusType.info:
        color = AppColors.info;
        icon = Icons.info;
        break;
      case StatusType.pending:
        color = AppColors.warning;
        icon = Icons.schedule;
        break;
      case StatusType.processing:
        color = AppColors.info;
        icon = Icons.autorenew;
        break;
    }

    return BadgeChip(
      label: label,
      color: color,
      icon: icon,
    );
  }
}

enum StatusType {
  success,
  error,
  warning,
  info,
  pending,
  processing,
}
