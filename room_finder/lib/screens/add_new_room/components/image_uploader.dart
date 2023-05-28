import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../../../model/room.dart';
import '../../login_screen/components/my_button.dart';
class ImageUploader extends StatefulWidget {
  final Room? room;
  final String roomId;
   ImageUploader({Key? key, required this.roomId,this.room}) : super(key: key);

  @override
  State<ImageUploader> createState() => _ImageUploaderState();
}

class _ImageUploaderState extends State<ImageUploader> {


  List<File> _imageFiles = [];
  late BuildContext loadingContext;

  final picker = ImagePicker();



  void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        loadingContext = context; // store the context of the loading dialog
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  void hideLoadingDialog() {
    Navigator.pop(loadingContext); // use the stored context to remove the loading dialog
  }


  Future getImage() async {
    final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,imageQuality: 80);

    if (pickedFile != null) {
      setState(() {
        _imageFiles.add(File(pickedFile.path));
      });
    }else{
      print('No image Picked');
    }
  }

  Future<List<String>> uploadImages(String roomId) async {
    List<String> downloadUrls = [];


    for (var file in _imageFiles) {
      // Create a reference to the location where you want to store the file in Firebase Storage
      String fileName = file.path.split(Platform.pathSeparator).last;

      Reference ref = FirebaseStorage.instance.ref().child('room_images/$roomId/$fileName');

      // Upload the file to Firebase Storage
      UploadTask uploadTask = ref.putFile(file);
      TaskSnapshot snapshot = await uploadTask.whenComplete(() => null);

      // Get the download URL for the uploaded file
      String downloadUrl = await snapshot.ref.getDownloadURL();

      // Save the download URL in Cloud Firestore for the room document



      downloadUrls.add(downloadUrl);
    }



    CollectionReference roomsRef = FirebaseFirestore.instance.collection('rooms');
    DocumentReference roomDocument = roomsRef.doc(roomId);




    await roomDocument.set({
      'name': "Pg",
      'ownerName':"Pg owner",
      'ownerNumber':"6394691921",
      'property size':"100sq ft",
      'address':"Unknown",
      'description': "Describe",
      'latitude': 37.4219999,
      'longitude':-122.0840575,
      'singlePrice':'0',
      'doublePrice' : '0',
      'triplePrice' : '0',
      'hasFPower' : false,
      'hasFMeals' : false,
      'hasFKitchen' : false,
      'hasFParking' : false,
      'hasFAirCond' : false,
      'hasFCCTV' : false,
      'userId' : "new",
      'roomId': "room",
      'popularity': 0,
      'timestamp': FieldValue.serverTimestamp(),
      'imageUrls': []});

    await roomDocument.update({'imageUrls': downloadUrls});


    return downloadUrls;
  }
  Future deleteRoomImages(String roomId) async {
    print('Deleting images for room $roomId');

    // Get a reference to the Firebase storage folder of the room
    final roomFolderRef = FirebaseStorage.instance.ref().child('room_images/$roomId');


    try {
      // List all the files in the room folder
      final roomFiles = await roomFolderRef.listAll();
     // print('Found ${roomFiles.items.length} items in room folder');

      // Loop through the files and delete them one by one
      for (final file in roomFiles.items) {
       // print('Deleting file ${file.name}');
        await file.delete();
      }

      //print('All images for room $roomId deleted successfully');
    } catch (e) {
      print('Error deleting room images: $e');
    }
  }


  Future<List<String>> updateImages(String roomId) async {
    List<String> downloadUrls = [];

    await deleteRoomImages(roomId);


    for (var file in _imageFiles) {
      // Create a reference to the location where you want to store the file in Firebase Storage
      String fileName = file.path.split(Platform.pathSeparator).last;

      Reference ref = FirebaseStorage.instance.ref().child('room_images/$roomId/$fileName');

      // Upload the file to Firebase Storage
      UploadTask uploadTask = ref.putFile(file);
      TaskSnapshot snapshot = await uploadTask.whenComplete(() => null);

      // Get the download URL for the uploaded file
      String downloadUrl = await snapshot.ref.getDownloadURL();

      // Save the download URL in Cloud Firestore for the room document



      downloadUrls.add(downloadUrl);
    }



    CollectionReference roomsRef = FirebaseFirestore.instance.collection('rooms');
    DocumentReference roomDocument = roomsRef.doc(roomId);


    await roomDocument.update({'imageUrls': downloadUrls});


    return downloadUrls;
  }



  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: InkWell(
            onTap: (){
              getImage();
            },
            child: Container(height: 200 ,width: 200, decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
            ),
            child: _imageFiles.isNotEmpty ? PageView(
    children: _imageFiles
        .map((e) => Container(
    width: MediaQuery.of(context).size.width,
    height: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: FileImage(e),
        ),
      ),
    ))
        .toList(),
    )
        : Center(child: Icon(Icons.image),),),
          ),
        ),
        SizedBox(height: 20,),
        MyButton(buttonText: 'Upload',onTap: () async {
          showLoadingDialog(context);
          try{
            if(widget.room == null){
              await uploadImages(widget.roomId);
            }else{
              //deleteRoomImages(widget.roomId);
              await updateImages(widget.roomId);

            }

            hideLoadingDialog();

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Images uploaded.'),
                duration: Duration(seconds: 2),
              ),
            );
          }catch (e){
            hideLoadingDialog();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('There was an error'),
                duration: Duration(seconds: 2),
              ),
            );

          }



          setState(() {
            _imageFiles.clear();
          });
        },)
      ],
    );
  }
}
