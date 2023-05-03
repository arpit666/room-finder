import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:room_finder/screens/home_screen/components/custom_navigation_bar.dart';
import 'package:room_finder/screens/home_screen/components/room_tile.dart';

import '../../model/room.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({Key? key}) : super(key: key);

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {

  late BuildContext loadingContext;

  List _favoriteRooms = [];

  bool _isLoading = true;

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

  void hideLoadingDialog(BuildContext context) {
    Navigator.of(context).pop();
  }


  Future<void> _getFavoriteRooms() async {

    final User? user = FirebaseAuth.instance.currentUser;


    if (user != null) {
      final DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      final List<dynamic> favoriteRoomIds = List<String>.from(userDoc.get('favoriteRooms') ?? []);

      final List<Room> favoriteRooms = [];
      for (final roomId in favoriteRoomIds) {
        final DocumentSnapshot roomDoc = await FirebaseFirestore.instance.collection('rooms').doc(roomId).get();
        if (roomDoc.exists) {

          final Room room = Room.fromMap(roomDoc.data() as Map<String,dynamic>);
          favoriteRooms.add(room);
        }

      }


      setState(() {
        _favoriteRooms = favoriteRooms;
        _isLoading = false;
      });

    }else{
      setState(() {
        _isLoading = false;
      });
    }


  }

  @override
  void initState() {
    _getFavoriteRooms();
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    final selectedIndex = PageStorage.of(context).readState(context) ?? 3;

    return Scaffold(
      appBar: AppBar(title: Text('Favorites',style: Theme.of(context)
          .textTheme
          .headlineLarge!
          .copyWith(fontSize: 20, fontWeight: FontWeight.w600),),),
      body: _isLoading ? Center(child: CircularProgressIndicator(),) : ListView.builder(
        itemCount: _favoriteRooms.length,
        itemBuilder: (context, index) {
          final Room room = _favoriteRooms[index];
          return RoomTile(room: room,isFavorited:true,isFavScreen: true,);
        },
      ),
      bottomNavigationBar: CustomNavigationBar(
        initialIndex: selectedIndex,
      ),
    );
  }
}
