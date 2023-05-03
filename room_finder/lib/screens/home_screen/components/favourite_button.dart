import 'package:flutter/material.dart';

class FavoriteButton extends StatelessWidget {
  final bool isFavorited;
  final Function()? onPressed;

  FavoriteButton({
    required this.isFavorited,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 25.0,
      width: 27.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isFavorited ? Colors.red : Colors.grey[300],
      ),
      child: IconButton(
        icon: Icon(
          Icons.favorite,
          color: isFavorited ? Colors.white : Colors.grey[700],
          size: 12,
        ),
        onPressed: onPressed,
      ),
    );
  }
}

class FavoriteHeartPainter extends CustomPainter {
  final double progress;

  FavoriteHeartPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.fill;

    Path path = Path();
    path.moveTo(0, size.height / 2);
    path.cubicTo(size.width / 4, size.height, size.width / 2, 0, size.width,
        size.height / 2);
    path.cubicTo(size.width / 2, size.height, size.width * 3 / 4, 0, size.width,
        size.height / 2);
    path.lineTo(0, size.height / 2);
    path.close();

    canvas.drawPath(path, paint);

    paint.color = Colors.white;
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width * progress / 2,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
