import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:room_finder/screens/home_screen/home_screen.dart';
import 'package:room_finder/screens/login_screen/login_screen.dart';
import 'package:room_finder/screens/register_screen/login_or_register.dart';

class UserAuth extends StatelessWidget {
  const UserAuth({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.userChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return HomeScreen();
          } else {
            return LoginOrRegister();
          }
        },
      ),
    );
  }
}
