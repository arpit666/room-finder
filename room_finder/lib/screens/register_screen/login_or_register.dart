import 'package:flutter/material.dart';
import 'package:room_finder/screens/login_screen/login_screen.dart';
import 'package:room_finder/screens/register_screen/register_screen.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({Key? key}) : super(key: key);

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  bool showingLoginPage = true;

  void togglePages() {
    setState(() {
      showingLoginPage = !showingLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showingLoginPage) {
      return LoginScreen(onTap: togglePages);
    }
    return RegisterScreen(
      onTap: togglePages,
    );
  }
}
