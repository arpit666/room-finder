import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:room_finder/screens/chat_screen/components/apis.dart';

import '../../add_new_room/add_new_room_screen.dart';
import '../../chat_screen/main_chat_screen.dart';
import '../../favourite_screen/favourite_screen.dart';
import '../../profile_screen/profile_screen.dart';
import '../home_screen.dart';


class CustomNavigationBar extends StatefulWidget {
  final int? initialIndex;

  CustomNavigationBar({Key? key, required this.initialIndex}) : super(key: key);

  @override
  State<CustomNavigationBar> createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<CustomNavigationBar> {
  late int _selectedIndex ;
  String role = '';

  final List bottomBarItem = [
    Icons.home_filled,
    Icons.message,
    Icons.add_circle,
    Icons.favorite_outlined,
    Icons.person
  ];

  final List bottomBarItemUser = [
    Icons.home_filled,
    Icons.message,
    Icons.favorite_outlined,
    Icons.person
  ];

  final List bottomBarItemNames = [
    'home',
    'chat',
    'add room',
    'favorite',
    'profile'
  ];

  final List bottomBarItemNamesUser = [
    'home',
    'chat',
    'favorite',
    'profile'
  ];

  final List<Widget> _screens = [
    HomeScreen(),
    MainChatScreen(),
    AddNewRoomScreen(),
    FavouriteScreen(),
    ProfileScreen()
  ];

  final List<Widget> _screensUser = [
    HomeScreen(),
    MainChatScreen(),
    FavouriteScreen(),
    ProfileScreen()
  ];

  Future getDetails() async {
    final userDocRef =
    FirebaseFirestore.instance.collection('users').doc(APIs.user.uid);
    final userDocSnapshot = await userDocRef.get();
    final userDocData = userDocSnapshot.data() as Map<String, dynamic>;
    setState(() {
      role = userDocData['role'];
    });
  }
  void initiate()async{
    await getDetails();
    if (role == 'owner') {
      _selectedIndex = widget.initialIndex ?? 0;
    } else {
      _selectedIndex = widget.initialIndex == 3 ? 2 : widget.initialIndex == 4 ? 3: widget.initialIndex ?? 0;
    }
  }

  void _onItemTapped(BuildContext context, int index) {
    PageStorage.of(context).writeState(context, index);
    List res;
    if(role == 'owner'){
      res = _screens;
    }else{
      res = _screensUser;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => res[index],
      ),
    );
  }

  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex ?? 0;
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      initiate();
    });

  }

  @override
  Widget build(BuildContext context) {
    List bottomBarItems;
    List bottomBarItemName;

    if (role == 'owner') {
      bottomBarItems = bottomBarItem;
      bottomBarItemName = bottomBarItemNames;
    } else {
      bottomBarItems = bottomBarItemUser;
      bottomBarItemName = bottomBarItemNamesUser;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 25, left: 15, right: 15),
      padding: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 7,
            offset: Offset(0, 3),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(bottomBarItems.length, (index) {
          return GestureDetector(
            onTap: () => _onItemTapped(context, index),
            child: BottomIcons(
              bottomBarItemName[index],
              bottomBarItems[index],
              _selectedIndex == index
                  ? Theme.of(context).primaryColor
                  : Colors.grey.shade400,
            ),
          );
        }),
      ),
    );
  }
}


class BottomIcons extends StatelessWidget {
  final String text;
  final IconData icon;
  Color color;

  BottomIcons(this.text,this.icon,this.color);


  @override
  Widget build(BuildContext context) {
    return  Column(
      mainAxisSize: MainAxisSize.min,
      children: [Icon(
          icon,color: color,
      ),
        Text(text,style: TextStyle(color: color,fontSize: 10),),
      ],
    );
  }
}



