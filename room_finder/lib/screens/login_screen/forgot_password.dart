import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:room_finder/screens/login_screen/components/my_textfield.dart';
import 'package:room_finder/screens/login_screen/components/my_button.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future passwordReset() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text.trim(),
      );
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text('Password reset link sent! Check your email.'),
            );
          });
    } on FirebaseException catch (e) {
      print(e);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(e.message.toString()),
            );
          });
    }
  }

  final String _hintText = 'email';
  final String _buttonText = 'Reset Password';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey.shade400,
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Enter Your Email'),
          const SizedBox(
            height: 25,
          ),
          MyTextField(
              controller: _emailController,
              hintText: _hintText,
              obscureText: false),
          const SizedBox(
            height: 25,
          ),
          MyButton(onTap: passwordReset, buttonText: _buttonText)
        ],
      ),
    );
  }
}
