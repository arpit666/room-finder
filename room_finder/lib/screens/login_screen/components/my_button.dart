import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  const MyButton({Key? key, required this.onTap, required this.buttonText})
      : super(key: key);

  final Function()? onTap;
  final String buttonText;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: Colors.black, borderRadius: BorderRadius.circular(8)),
        child: Center(
          child: Text(
            buttonText,
            style: TextStyle(color: Colors.white,fontSize: 16),
          ),
        ),
      ),
    );
  }
}
