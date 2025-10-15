import 'package:farmbros_mobile/core/configs/Utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class FarmBrosLoadingState extends StatefulWidget {
  const FarmBrosLoadingState({super.key});

  @override
  State<FarmBrosLoadingState> createState() => _FarmBrosLoadingStateState();
}

class _FarmBrosLoadingStateState extends State<FarmBrosLoadingState>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _rotationController;
  late AnimationController _scaleController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Fade animation for text and logo
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _fadeAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    // Rotation animation for the circular loader
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    // Scale animation for pulsing effect
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _rotationController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: ColorUtils.lightBackgroundColor,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FadeTransition(
            opacity: _fadeAnimation,
            child: const Text(
              "Loading . . .",
              style: TextStyle(
                fontFamily: "Poppins",
                decoration: TextDecoration.none,
                color: ColorUtils.splashScreenBackground,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 40),

          // Custom animated loader
          Stack(
            alignment: Alignment.center,
            children: [
              // Outer rotating ring
              AnimatedBuilder(
                animation: _rotationController,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _rotationController.value * 2 * math.pi,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: ColorUtils.successColor.withOpacity(0.3),
                          width: 3,
                        ),
                      ),
                      child: CustomPaint(
                        painter: LeafCirclePainter(
                          progress: _rotationController.value,
                        ),
                      ),
                    ),
                  );
                },
              ),

              // Middle pulsing circle
              ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: ColorUtils.successColor.withOpacity(0.1),
                    border: Border.all(
                      color: ColorUtils.successColor.withOpacity(0.4),
                      width: 2,
                    ),
                  ),
                ),
              ),

              // Inner logo
              FadeTransition(
                opacity: _fadeAnimation,
                child: Image.asset(
                  "assets/images/farm_bros_icon.png",
                  height: 60,
                  width: 60,
                ),
              ),
            ],
          ),

          const SizedBox(height: 40),

          // Animated dots
          AnimatedBuilder(
            animation: _fadeController,
            builder: (context, child) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (index) {
                  final delay = index * 0.3;
                  final animationValue = (_fadeController.value + delay) % 1.0;
                  final opacity = (math.sin(animationValue * math.pi * 2) + 1) / 2;

                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: ColorUtils.successColor.withOpacity(opacity),
                    ),
                  );
                }),
              );
            },
          ),
        ],
      ),
    );
  }
}

// Custom painter for leaf/farm-themed arc
class LeafCirclePainter extends CustomPainter {
  final double progress;

  LeafCirclePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = ColorUtils.successColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw animated arc
    final sweepAngle = 2 * math.pi * 0.7;
    final startAngle = progress * 2 * math.pi;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      paint,
    );

    // Draw small leaf indicators at intervals
    for (int i = 0; i < 4; i++) {
      final angle = (i * math.pi / 2) + (progress * 2 * math.pi);
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);

      canvas.drawCircle(
        Offset(x, y),
        3,
        Paint()
          ..color = ColorUtils.successColor
          ..style = PaintingStyle.fill,
      );
    }
  }

  @override
  bool shouldRepaint(LeafCirclePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}