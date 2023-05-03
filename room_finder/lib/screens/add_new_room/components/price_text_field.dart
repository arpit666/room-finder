import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'num_text_formatter.dart';
class PriceTextField extends StatelessWidget {
  final TextEditingController myController ;
  final String hintText;
  const PriceTextField({Key? key, required this.myController, required this.hintText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: TextField(
        controller: myController,
        keyboardType: TextInputType.number,
        inputFormatters: [
          NumericTextFormatter(),
          LengthLimitingTextInputFormatter(20),
        ],
        decoration: InputDecoration(
            fillColor: Colors.grey.shade200,
            filled: true,
            labelStyle: TextStyle(color: Colors.grey.shade500),
            labelText: hintText,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade400))),
      ),
    );
  }
}
