import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:room_finder/main.dart';
import 'package:room_finder/screens/chat_screen/components/apis.dart';
import 'package:room_finder/screens/home_screen/components/room_tile.dart';
import 'package:room_finder/screens/register_screen/login_or_register.dart';

import '../../model/room.dart';
import '../login_screen/login_screen.dart';
import 'package:geolocator/geolocator.dart';
import 'components/custom_navigation_bar.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final user = FirebaseAuth.instance.currentUser!;

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  var searchText = TextEditingController();

  late BuildContext loadingContext;

  bool _isSearching = false;

  String name = '';

  List searchList =[];

   List rooms = [
    // Room(
    //     title: 'H1hkvh',
    //     location: '69 Shivkuti ,Teliarganj , Prayagraj',
    //     ownerName: 'Pawan',
    //     ownerNumber: '917233018495',
    //     priceSingle: '3000',
    //     priceTwin: '2000',
    //     priceThree: '1000',
    //     hasSingle: true,
    //     hasDouble: true,
    //     hasThree: true,
    //     imageUrl: ['https://via.placeholder.com/300x200'],
    //     latitude: 25.0,longitude: 26.0,description: 'describe',propertySize: '500ft'),
    // Room(
    //     title: 'H1',
    //     ownerNumber: '917233018495',
    //     location: 'Prayag',
    //     ownerName: 'Pawan',
    //     priceSingle: '3000',
    //     priceTwin: '2000',
    //     priceThree: '1000',
    //     hasSingle: true,
    //     hasDouble: true,
    //     hasThree: true,
    //     imageUrl:
    //         ['https://cdn.pixabay.com/photo/2016/11/18/17/20/living-room-1835923_960_720.jpg'],
    // latitude: 25.0,longitude: 26.0,description: 'describe',propertySize: '500ft'),
  ];

  List<String> _favoriteRoomIds = [];

  Future<void> _getFavoriteRooms() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final DocumentSnapshot userDoc =
      await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      final List<dynamic> favoriteRooms = userDoc.get('favoriteRooms') ?? [];
      setState(() {
        _favoriteRoomIds = List<String>.from(favoriteRooms);
      });
    }
  }
  Future getOwnerDetails() async {
    final userDocRef =
    FirebaseFirestore.instance.collection('users').doc(APIs.user.uid);
    final userDocSnapshot = await userDocRef.get();
    final userDocData = userDocSnapshot.data() as Map<String, dynamic>;
    setState(() {
      name = userDocData['name'];

    });
  }

  bool _isRoomFavorite(String roomId) {
    return _favoriteRoomIds.contains(roomId);
  }

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
  void signUserOut() async {
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (BuildContext context) {
      return MyApp();
    }), (Route<dynamic> route) => false);
    await FirebaseAuth.instance.signOut();
    await _googleSignIn.signOut();


  }

  Future<void> _getRoomsInCurrentLocation() async {

    LocationPermission permission;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }


    setState(() {
      rooms = []; // Clear out the old rooms
    });

    showLoadingDialog(context);

    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    final QuerySnapshot snapshot =
    await FirebaseFirestore.instance.collection('rooms').get();
    final List filteredRooms = snapshot.docs.map((DocumentSnapshot document) => Room.fromMap(document.data() as Map<String, dynamic>) )
        .where((room) =>
    Geolocator.distanceBetween(position.latitude, position.longitude,
        room.latitude, room.longitude) <=
        10000)
        .toList();

    setState(() {
      rooms = filteredRooms;
    });

    hideLoadingDialog();
  }

  Future<void> _getRoomsInSearchedLocation() async{
    setState(() {
      rooms = []; // Clear out the old rooms
    });

    showLoadingDialog(context);
    final QuerySnapshot snapshot =
    await FirebaseFirestore.instance.collection('rooms').get();

    List<Room> allRooms = snapshot.docs
        .map((DocumentSnapshot document) =>
        Room.fromMap(document.data() as Map<String, dynamic>))
        .toList();

    final searchTextValue = searchText.text.trim().toLowerCase();

    List<Room> filteredRooms = allRooms
        .where((room) =>
    (room.title?.toLowerCase()?.contains(searchTextValue) ?? false) ||
        (room.location?.toLowerCase()?.contains(searchTextValue) ?? false))
        .toList();

    setState(() {
      rooms = filteredRooms;
    });
    hideLoadingDialog();
  }



  @override
  void initState() {
   _getRoomsInCurrentLocation();
   _getFavoriteRooms();
   getOwnerDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = PageStorage.of(context).readState(context) ?? 0;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Hello, ${name}',
          style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.black45),
        ),
        actions: [IconButton(onPressed: ()async{
          if(searchText.text.isEmpty){
            await _getRoomsInCurrentLocation();
          }else{
            await _getRoomsInSearchedLocation();
          }
        }, icon: Icon(Icons.logout))],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 10),
            Text(
              'Find your sweet PG',
              style: Theme.of(context)
                  .textTheme
                  .headlineLarge!
                  .copyWith(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            GestureDetector(
              onTap: (){
                setState(() {
                  _isSearching = true;
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          onSubmitted: (_) async{
                            if(searchText.text.isEmpty){
                              await _getRoomsInCurrentLocation();
                            }else{
                              await _getRoomsInSearchedLocation();
                            }
                          },

                          controller: searchText,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.search),
                            hintText: "Search for rooms...",
                            border: InputBorder.none
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: rooms.length,
                itemBuilder: (context, index) {
                  final Room room = rooms[index];
                  return RoomTile(room: room,isFavorited: _isRoomFavorite(room.roomId!),isFavScreen: false,);
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomNavigationBar(
        initialIndex: selectedIndex,
      ),
    );
  }
}
