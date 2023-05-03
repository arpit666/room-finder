import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../model/room.dart';
import '../home_screen/components/room_tile.dart';
import 'modify_room_screen.dart';
import 'my_room_tile.dart';

class MyRooms extends StatefulWidget {
  const MyRooms({Key? key}) : super(key: key);

  @override
  State<MyRooms> createState() => _MyRoomsState();
}

class _MyRoomsState extends State<MyRooms> {

  List rooms = [];
  final user = FirebaseAuth.instance.currentUser;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Rooms',style: Theme.of(context).textTheme.headlineLarge!.copyWith(fontSize: 18,fontWeight: FontWeight.w700),),),
      body: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: StreamBuilder<QuerySnapshot>(
          stream:  FirebaseFirestore.instance.collection('rooms').where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid).snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }

            if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
              return Scaffold(body: Center(child: Text('Rooms not found'),),);
            }

            // Display the list of rooms and allow user to select a room for modification
            return ListView.builder(

              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final roomData = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                final room = Room.fromMap(roomData); // Convert Map to Room object
                return MyRoomTile(room: room);
              },
            );
          },
        ),
      ),
    );

  }
}
