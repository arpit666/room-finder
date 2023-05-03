import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:room_finder/main.dart';
import 'package:room_finder/screens/home_screen/components/custom_navigation_bar.dart';
import 'package:room_finder/screens/login_screen/login_screen.dart';
import 'package:room_finder/screens/profile_screen/update_profile_screen.dart';
import 'package:room_finder/screens/register_screen/login_or_register.dart';
import 'dart:io';

import '../../model/room.dart';
import '../../model/user_model.dart';
import 'my_rooms.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var _image;

  final User user = FirebaseAuth.instance.currentUser!;
   late String userName ;
   late String userMail  ;
   late String userPhone;
   late String userProf ;
   
   bool _isLoading = true;


  final GoogleSignIn _googleSignIn = GoogleSignIn();

  void getUserDetails()async{
    if (user != null) {
      final DocumentSnapshot userDoc =
      await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if(userDoc.exists){
        userName = userDoc.get('name');
        userMail = userDoc.get('email');
        userPhone = userDoc.get('phone');
        userProf = userDoc.get('profile_picture');
      }else{
        userName = 'Profile Name';
        userMail = 'Profile Mail';
        userPhone = '446';
        userProf = '';
      }




    }
    setState(() {
      _isLoading = false;
    });

  }

  void _changeProfileImage() async {
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);
    File file = File(image!.path);
    setState(() {
      _image = file;
    });
  }

  void signUserOut() async {
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (BuildContext context) {
      return MyApp();
    }), (Route<dynamic> route) => false);
    await FirebaseAuth.instance.signOut();
    await _googleSignIn.signOut();
  }

  @override
  void initState() {
    getUserDetails();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final selectedIndex = PageStorage.of(context).readState(context) ?? 4;

    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: Center(
          child: Text(
            "Profile",
            style: Theme.of(context)
                .textTheme
                .headlineLarge!
                .copyWith(fontSize: 20, fontWeight: FontWeight.w600),
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                isDark ? LineAwesomeIcons.sun : LineAwesomeIcons.moon,
                color: Colors.black,
              ))
        ],
      ),
      body: _isLoading ? Center(child: CircularProgressIndicator()): SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(40),
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blueGrey),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image(
                        image: userProf != ''
                            ? NetworkImage(userProf)
                            : NetworkImage('https://picsum.photos/200')
                                as ImageProvider,
                      ),
                    ),
                  ),
                  // Positioned(
                  //   bottom: 0,
                  //   right: 0,
                  //   child: GestureDetector(
                  //     onTap: _changeProfileImage,
                  //     child: Container(
                  //       width: 35,
                  //       height: 35,
                  //       decoration: BoxDecoration(
                  //         borderRadius: BorderRadius.circular(100),
                  //         color: Colors.yellow.shade600,
                  //       ),
                  //       child: const Icon(
                  //         LineAwesomeIcons.camera,
                  //         size: 20,
                  //         color: Colors.black,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                userName =='' ? 'Profile Name' : userName,
                style: Theme.of(context)
                    .textTheme
                    .headlineLarge!
                    .copyWith(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                userMail ,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontSize: 16),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => UpdateProfileScreen(userMail: userMail,userName: userName,userPhone: userPhone,profPic: userProf,),
                      ),
                    );
                  },
                  child: const Text(
                    'Edit Profile',
                    style: TextStyle(color: Colors.black),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow.shade600,
                    side: BorderSide.none,
                    shape: const StadiumBorder(),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(),
              const SizedBox(
                height: 10,
              ),
              ProfileMenu(
                title: 'Settings',
                onPress: () {},
                iconData: LineAwesomeIcons.cog,
              ),
              ProfileMenu(
                title: 'My Rooms',
                onPress: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyRooms()));
                },
                iconData: LineAwesomeIcons.info,
              ),
              ProfileMenu(
                title: 'Logout',
                onPress: signUserOut,
                iconData: LineAwesomeIcons.alternate_sign_out,
                textColor: Colors.red,
                endIcon: false,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomNavigationBar(
        initialIndex: selectedIndex,
      ),
    );
  }
}

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({
    Key? key,
    required this.title,
    required this.onPress,
    required this.iconData,
    this.endIcon = true,
    this.textColor,
  }) : super(key: key);

  final String title;
  final IconData iconData;
  final onPress;
  final bool endIcon;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPress,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Colors.blue.withOpacity(0.1),
        ),
        child: Icon(
          iconData,
          color: Colors.indigoAccent,
        ),
      ),
      title: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .bodyMedium!
            .copyWith(fontWeight: FontWeight.bold)
            .apply(color: textColor),
      ),
      trailing: endIcon
          ? Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.grey.withOpacity(0.1),
              ),
              child: const Icon(
                LineAwesomeIcons.angle_right,
                size: 18,
                color: Colors.grey,
              ),
            )
          : null,
    );
  }
}
