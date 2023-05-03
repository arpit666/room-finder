import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:room_finder/screens/login_screen/user_auth.dart';
import 'firebase_options.dart';
import 'screens/login_screen/login_screen.dart';





void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((value) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: UserAuth(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(
            iconTheme: IconThemeData(color: Colors.black),
            color: Colors.blueGrey.shade300),
        primaryColor: Color(0xFF811B83),
        textTheme: TextTheme(
          headlineLarge: TextStyle(
            color: Color(0xFF100E34),
          ),
          bodyLarge: TextStyle(color: Color(0xFF100E34).withOpacity(0.5)),
          headlineMedium: TextStyle(color: Colors.red),
          headlineSmall: TextStyle(fontSize: 18,fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}