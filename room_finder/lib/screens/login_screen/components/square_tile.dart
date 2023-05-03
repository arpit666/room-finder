import 'package:flutter/material.dart';

class SquareTile extends StatelessWidget {
  const SquareTile({Key? key, required this.imagePath, required this.onTap})
      : super(key: key);

  final String imagePath;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white),
            color: Colors.grey.shade200),
        child: Image.asset(
          imagePath,
          height: 40,
        ),
      ),
    );
  }
}
