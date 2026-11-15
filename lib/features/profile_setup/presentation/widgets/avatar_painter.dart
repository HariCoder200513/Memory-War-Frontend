import 'dart:math';
import 'package:flutter/material.dart';
import '../../data/avatar_data.dart';

class AvatarWidget extends StatelessWidget {
  final AvatarOption avatar;
  final double size;
  final bool selected;

  const AvatarWidget({
    super.key,
    required this.avatar,
    required this.size,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: avatar.backgroundColor,
        borderRadius: BorderRadius.circular(size * 0.22),
        border: selected
            ? Border.all(color: const Color(0xFFFFB547), width: 3)
            : null,
      ),
      child: CustomPaint(
        painter: _ShapePainter(
          shape: avatar.shape,
          color: avatar.shapeColor,
        ),
      ),
    );
  }
}

class _ShapePainter extends CustomPainter {
  final AvatarShape shape;
  final Color color;

  _ShapePainter({required this.shape, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width * 0.28;

    switch (shape) {
      case AvatarShape.circle:
        canvas.drawCircle(Offset(cx, cy), r, paint);
        break;

      case AvatarShape.triangle:
        final path = Path();
        path.moveTo(cx, cy - r);
        path.lineTo(cx - r * 0.95, cy + r * 0.65);
        path.lineTo(cx + r * 0.95, cy + r * 0.65);
        path.close();
        canvas.drawPath(path, paint);
        break;

      case AvatarShape.diamond:
        final path = Path();
        path.moveTo(cx, cy - r);
        path.lineTo(cx + r, cy);
        path.lineTo(cx, cy + r);
        path.lineTo(cx - r, cy);
        path.close();
        canvas.drawPath(path, paint);
        break;

      case AvatarShape.square:
        final half = r * 0.75;
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(center: Offset(cx, cy), width: half * 2, height: half * 2),
            Radius.circular(half * 0.15),
          ),
          paint,
        );
        break;

      case AvatarShape.star:
        _drawStar(canvas, cx, cy, r, paint);
        break;

      case AvatarShape.hexagon:
        _drawPolygon(canvas, cx, cy, r, 6, paint);
        break;

      case AvatarShape.plus:
        final arm = r * 0.35;
        final path = Path();
        path.addRect(Rect.fromCenter(center: Offset(cx, cy), width: arm * 2, height: r * 2));
        path.addRect(Rect.fromCenter(center: Offset(cx, cy), width: r * 2, height: arm * 2));
        canvas.drawPath(path, paint);
        break;

      case AvatarShape.drop:
        final path = Path();
        path.moveTo(cx, cy - r);
        path.quadraticBezierTo(cx + r * 1.2, cy - r * 0.2, cx + r * 0.6, cy + r * 0.5);
        path.quadraticBezierTo(cx, cy + r * 1.1, cx, cy + r * 1.1);
        path.quadraticBezierTo(cx, cy + r * 1.1, cx - r * 0.6, cy + r * 0.5);
        path.quadraticBezierTo(cx - r * 1.2, cy - r * 0.2, cx, cy - r);
        path.close();
        canvas.drawPath(path, paint);
        break;
    }
  }

  void _drawStar(Canvas canvas, double cx, double cy, double r, Paint paint) {
    final path = Path();
    final innerR = r * 0.45;
    for (int i = 0; i < 5; i++) {
      final outerAngle = (i * 72 - 90) * pi / 180;
      final innerAngle = ((i * 72) + 36 - 90) * pi / 180;
      final ox = cx + r * cos(outerAngle);
      final oy = cy + r * sin(outerAngle);
      final ix = cx + innerR * cos(innerAngle);
      final iy = cy + innerR * sin(innerAngle);
      if (i == 0) {
        path.moveTo(ox, oy);
      } else {
        path.lineTo(ox, oy);
      }
      path.lineTo(ix, iy);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawPolygon(Canvas canvas, double cx, double cy, double r, int sides, Paint paint) {
    final path = Path();
    for (int i = 0; i < sides; i++) {
      final angle = (i * 360 / sides - 90) * pi / 180;
      final x = cx + r * cos(angle);
      final y = cy + r * sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _ShapePainter oldDelegate) {
    return oldDelegate.shape != shape || oldDelegate.color != color;
  }
}
