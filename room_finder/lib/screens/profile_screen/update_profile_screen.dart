import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:room_finder/screens/login_screen/components/my_textfield.dart';
import 'package:room_finder/screens/profile_screen/profile_screen.dart';

class UpdateProfileScreen extends StatefulWidget {

  final String userName;
  final String userMail;
  final String userPhone;
  final String profPic;
  const UpdateProfileScreen({Key? key,required this.userName,required this.userPhone, required this.userMail,required this.profPic}) : super(key: key);

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  File? _image;
  
  
  
  bool _isLoading = false;
  final userId = FirebaseAuth.instance.currentUser!.uid;


  late final nameController;
  late final emailController ;

  late final numberController ;
  //final passwordController = TextEditingController();


  Future<String> getApplicationSupportDirectoryPath() async {
    final directory = await getApplicationSupportDirectory();
    return directory.path;
  }

  @override
  void initState() {
    nameController = TextEditingController(text: widget.userName);
    emailController = TextEditingController(text: widget.userMail);
    numberController = TextEditingController(text: widget.userPhone);
    super.initState();
  }
  void _changeProfileImage() async {
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);
    File file = File(image!.path);
    setState(() {
      _image = file;
      _isLoading = true;
    });

    await updateProfileImage();

    setState(() {
      _isLoading = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Image updated successfully'),duration:Duration(seconds: 2) ,),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ProfileScreen()),
    );


  }
  Future updateProfileImage() async{
    String fileName = _image!.path.split(Platform.pathSeparator).last;
    Reference ref = FirebaseStorage.instance.ref().child('users/$userId/$fileName');

    UploadTask uploadTask = ref.putFile(_image!);
    TaskSnapshot snapshot = await uploadTask.whenComplete(() => null);


    String downloadUrl = await snapshot.ref.getDownloadURL();

    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'profile_picture': downloadUrl,
    });
  }


  Future updateUserDetails() async{
    final User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'name': nameController.text,
        'email': emailController.text,
        'phone': numberController.text,
      });

      // show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated successfully')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ProfileScreen()),
      );
    } else {
      // show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unable to update profile')),
      );
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Update Profile',
          style: Theme.of(context)
              .textTheme
              .headlineLarge!
              .copyWith(fontSize: 20, fontWeight: FontWeight.w600),
        ),

      ),
      body:   _isLoading ? Center(child: CircularProgressIndicator(),) : SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(30),
          child: Column(
            children: [
              Stack(
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image(
                        image: widget.profPic !=''
                            ? NetworkImage(widget.profPic)
                            : NetworkImage('https://picsum.photos/200')
                                as ImageProvider,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _changeProfileImage,
                      child: Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.yellow.shade600,
                        ),
                        child: const Icon(
                          LineAwesomeIcons.camera,
                          size: 20,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              Form(
                child: Column(
                  children: [
                    MyTextField(
                        controller: nameController,
                        hintText: 'Full Name',
                        obscureText: false),
                    SizedBox(
                      height: 20,
                    ),
                    MyTextField(
                        controller: emailController,
                        hintText: 'Email',
                        obscureText: false),
                    SizedBox(
                      height: 20,
                    ),
                    MyTextField(
                        controller: numberController,
                        hintText: 'Phone No.',
                        obscureText: false),

                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async{
                            await updateUserDetails();
                          },
                          child: const Text(
                            'Save Changes',
                            style: TextStyle(color: Colors.black),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.yellow.shade600,
                            side: BorderSide.none,
                            shape: const StadiumBorder(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
