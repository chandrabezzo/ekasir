import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../app/constant/app_colors.dart';

/// An animated counter widget that smoothly transitions between numbers
class AnimatedCounter extends StatefulWidget {
  final int count;
  final TextStyle? textStyle;
  final Duration duration;

  const AnimatedCounter({
    super.key,
    required this.count,
    this.textStyle,
    this.duration = const Duration(milliseconds: 500),
  });

  @override
  State<AnimatedCounter> createState() => _AnimatedCounterState();
}

class _AnimatedCounterState extends State<AnimatedCounter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  int _previousCount = 0;

  @override
  void initState() {
    super.initState();
    _previousCount = widget.count;
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = Tween<double>(
      begin: _previousCount.toDouble(),
      end: widget.count.toDouble(),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));
    _controller.forward();
  }

  @override
  void didUpdateWidget(AnimatedCounter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.count != widget.count) {
      _previousCount = oldWidget.count;
      _animation = Tween<double>(
        begin: _previousCount.toDouble(),
        end: widget.count.toDouble(),
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ));
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Text(
          _animation.value.toInt().toString(),
          style: widget.textStyle ??
              GoogleFonts.poppins(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
        );
      },
    );
  }
}
