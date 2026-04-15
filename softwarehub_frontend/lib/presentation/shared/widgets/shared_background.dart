import 'package:flutter/material.dart';
import 'dart:math' as math;

class SharedBackground extends StatelessWidget {
  final Widget child;

  const SharedBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      children: [
        Positioned.fill(
          child: CustomPaint(
            painter: UnifiedBackgroundPainter(
              color: theme.colorScheme.primary.withOpacity(0.05),
              icon: Icons.rocket_launch_outlined,
            ),
          ),
        ),
        Positioned.fill(
          child: child,
        ),
      ],
    );
  }
}

class UnifiedBackgroundPainter extends CustomPainter {
  final Color color;
  final IconData icon;

  UnifiedBackgroundPainter({
    required this.color,
    required this.icon,
  });

  double _randomNoise(int x, int y) {
    double noise = math.sin(x * 12.9898 + y * 78.233) * 43758.5453;
    return noise - noise.floor();
  }

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = color.withOpacity(0.08)
      ..strokeWidth = 1;

    const double iconSize = 45.0;

    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    textPainter.text = TextSpan(
      text: String.fromCharCode(icon.codePoint),
      style: TextStyle(
        fontSize: iconSize,
        fontFamily: icon.fontFamily,
        package: icon.fontPackage,
        color: color.withOpacity(0.05),
      ),
    );
    textPainter.layout();

    const double spacing = 120.0;
    const double rocketGap = 190.0;
    const double angle = -math.pi / 2;

    const double safeMargin = 15.0;
    final double maxJitterLinha = (rocketGap - iconSize - safeMargin) / 2;

    int corridorIndex = 0;

    for (double i = -size.height; i < size.width + spacing; i += spacing) {
      corridorIndex++;

      canvas.drawLine(
        Offset(i, 0),
        Offset(i + size.height, size.height),
        linePaint,
      );

      final double midX = i + spacing / 2;
      int iconIndex = 0;

      for (double t = 0.0; t < size.width + size.height; t += rocketGap) {
        iconIndex++;

        double randomLinha = _randomNoise(corridorIndex + 10, iconIndex + 10);

        double deslocamentoLinha = (randomLinha * 2 - 1) * maxJitterLinha;

        double jitterX = deslocamentoLinha;
        double jitterY = deslocamentoLinha;

        final double px = midX + t + jitterX;
        final double py = t + jitterY;

        if (px < -80 || px > size.width + 80) continue;
        if (py < -80 || py > size.height + 80) continue;

        canvas.save();
        canvas.translate(px, py);
        canvas.rotate(angle);

        textPainter.paint(
          canvas,
          Offset(-textPainter.width / 2, -textPainter.height / 2),
        );

        canvas.restore();
      }
    }
  }

  @override
  bool shouldRepaint(covariant UnifiedBackgroundPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.icon != icon;
  }
}