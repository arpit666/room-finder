import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:room_finder/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:room_finder/screens/login_screen/components/my_button.dart';
import 'package:room_finder/screens/login_screen/components/my_textfield.dart';
import 'package:room_finder/screens/login_screen/components/square_tile.dart';
import 'package:room_finder/screens/login_screen/forgot_password.dart';
import 'package:room_finder/screens/login_screen/google_auth.dart';

class LoginScreen extends StatefulWidget {
  final Function()? onTap;

  LoginScreen({Key? key, required this.onTap}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();
  bool isLoading = false;

  void signUserIn() async {
    setState(() {
      isLoading = true;
    });

    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);


      setState(() {
        isLoading = false;
      });


    } on FirebaseAuthException catch (e) {
      setState(() {
        isLoading = false;
      });

      if (e.code == 'user-not-found') {
        wrongMessage('Incorrect Email');
      } else if (e.code == 'wrong-password') {
        wrongMessage('Incorrect Password');
      } else {
        wrongMessage('Check Email or Password');
      }
    }
  }


  void wrongMessage(String mess) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(mess),
          );
        });
  }

  Future<void> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

    final user = userCredential.user;

    if (user != null) {
      // User signed in successfully
      final uid = user.uid ?? '';
      final name = user.displayName ?? '';
      final email = user.email ?? '';
      final phone = user.phoneNumber ?? '';
      await addUserToFirestore(uid, name, email,phone);
    } else {
      // Sign in failed
      // ...
      wrongMessage('Sign in failed');
    }
  }
   addUserToFirestore(String userId, String name, String email,String phone) async {
    // Get a reference to the Firestore collection that will store the users
    CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');

    // Create a new document in the users collection with the specified ID
    DocumentReference userDocument = usersCollection.doc(userId);

    // Add the user details as fields to the document

    await userDocument.set({
      'name': name,
      'email': email,
      'phone': phone,
      'favoriteRooms': [],
      'profile_picture': '',
      'about':'About text',
      'userId':userId,
      'pushToken' : 'Push Added',
      'chatIds':[],
      'role':'user'

    });
  }
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    // Cancel any active timers or streams here
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                const Icon(
                  Icons.lock,
                  size: 100,
                ),
                const SizedBox(height: 50),
                Text(
                  'Welcome back , you\'ve been missed!',
                  style: TextStyle(color: Colors.grey.shade800, fontSize: 16),
                ),
                const SizedBox(height: 25),
                MyTextField(
                  controller: emailController,
                  hintText: 'Username',
                  obscureText: false,
                ),
                const SizedBox(
                  height: 10,
                ),
                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) {
                              return ForgotPassword();
                            }),
                          );
                        },
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(color: Colors.lightBlue),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                isLoading ? const CircularProgressIndicator():
                MyButton(
                  buttonText: 'Sign In',
                  onTap: signUserIn,
                ),
                const SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey.shade400,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          'Or continue with',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey.shade400,
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SquareTile(
                        onTap:  () async {
        signInWithGoogle();
        },
                        imagePath: 'assets/images/google.png'),
                    const SizedBox(
                      width: 25,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Not a member?',
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: Text(
                          'Register Now',
                          style: TextStyle(color: Colors.lightBlue),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
