import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:room_finder/screens/favourite_screen/favourite_screen.dart';
import 'package:room_finder/screens/home_screen/components/favourite_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../model/room.dart';
import '../detail_screen/detail_screen.dart';

class RoomTile extends StatefulWidget {
  final Room room;
  bool isFavorited;
  bool isFavScreen;



  RoomTile({required this.room,required this.isFavorited,required this.isFavScreen});



  @override
  State<RoomTile> createState() => _RoomTileState();
}

class _RoomTileState extends State<RoomTile> {
  final currentUserUid = FirebaseAuth.instance.currentUser!.uid;





  void _navigateToDetailScreen(BuildContext context) {
    increasePopularity();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => DetailScreen(room: widget.room),
      ),
    );
  }

  String showPrice() {
    String price = '0';
    if (widget.room.priceSingle != '0')
      price = widget.room.priceSingle;
    else if (widget.room.priceTwin != '0')
      price = widget.room.priceTwin;
    else
      price = widget.room.priceThree;
    return price;
  }

  Future addToFavorites(String roomId) async {
    // Get the current user's Firestore document
    final userDoc = FirebaseFirestore.instance.collection('users').doc(currentUserUid);

    // Add the room ID to the user's favoriteRooms list
    await userDoc.update({
      'favoriteRooms': FieldValue.arrayUnion([roomId])
    });

    if(widget.isFavScreen){
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => FavouriteScreen()),
      );
    }

  }
  Future<void> removeRoomFromFavorites(String roomId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // User is not logged in
      return;
    }

    final userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);

    try {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final userDoc = await transaction.get(userRef);

        if (!userDoc.exists) {
          // User document does not exist
          return;
        }

        final favorites = List<String>.from(userDoc.get('favoriteRooms') ?? []);

        if (favorites.contains(roomId)) {
          // Room is already in favorites list
          favorites.remove(roomId);

          transaction.update(userRef, {'favoriteRooms': favorites});
        }
      });
      if(widget.isFavScreen){
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => FavouriteScreen()),
        );
      }

    } catch (e) {
      // Handle the error
    }
  }
  void increasePopularity() async{
    final roomDoc = FirebaseFirestore.instance.collection('rooms').doc(widget.room.roomId);
    int pp = widget.room.popularity++;
    await roomDoc.update({
      'popularity': pp
    });
  }

  @override
  void initState() {
    increasePopularity();
    super.initState();
  }




  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _navigateToDetailScreen(context),
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(8),
        ),

        child: Stack(
          children: [
            Row(
              children: [
                Container(
                  width: 150,
                  height: 80,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(widget.room.imageUrl[0]),
                          fit: BoxFit.cover),
                      borderRadius: BorderRadius.circular(8)),
                ),
                SizedBox(width: 10),
                Flexible(
                  child: Column(
                    children: [
                      Text(widget.room.title,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      Text(
                        widget.room.location,
                        style: TextStyle(
                            fontSize: 14, overflow: TextOverflow.ellipsis),
                      ),
                      SizedBox(height: 10),
                      Text(
                        '₹ '+ showPrice() ,
                        style: TextStyle(fontSize: 14),
                      )
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              right: 0,
              child: FavoriteButton(
                isFavorited: widget.isFavorited,
                onPressed: () async{
                  if(widget.isFavorited){
                    await removeRoomFromFavorites(widget.room.roomId!);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Removed from favorites'),
                        duration: Duration(seconds: 2),
                      ),
                    );

                  }else{
                    await addToFavorites(widget.room.roomId!);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Added to favorites'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                  setState(() {
                    widget.isFavorited = !widget.isFavorited;
                  });

                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
