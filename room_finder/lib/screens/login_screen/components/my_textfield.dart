

import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final controller;
  final String hintText;
  final bool obscureText;

  const MyTextField(
      {Key? key,
      required this.controller,
      required this.hintText,
      required this.obscureText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: TextFormField(
        validator:  (value){
    if(value == null || value.isEmpty){
    return 'Please Enter Some Text';
    }
    else null;
    },
        controller: controller,
        keyboardType: TextInputType.emailAddress,
        obscureText: obscureText,
        decoration: InputDecoration(
            //hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey.shade500),
            fillColor: Colors.grey.shade200,
            filled: true,
            labelStyle: TextStyle(color: Colors.grey.shade500),
            labelText: hintText,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade400),),),
      ),
    );
  }
}
