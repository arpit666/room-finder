import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

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
  late int _selectedIndex;
  final bottomBarItem = [
    Icons.home_filled,
    Icons.message,
    Icons.add_circle,
    Icons.favorite_outlined,
    Icons.person
  ];

  final List<Widget> _screens = [
    HomeScreen(),
    MainChatScreen(),
    AddNewRoomScreen(),
    FavouriteScreen(),
    ProfileScreen()
  ];

  void _onItemTapped(BuildContext context, int index) {
    PageStorage.of(context).writeState(context, index);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _screens[index],
      ),
    );
  }

  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 25),
      padding: EdgeInsets.symmetric(vertical: 15),
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
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(bottomBarItem.length, (index) {
          return GestureDetector(
            onTap: () => _onItemTapped(context, index),
            child: Icon(
              bottomBarItem[index],
              color: _selectedIndex == index
                  ? Theme.of(context).primaryColor
                  : Colors.grey.shade400,
            ),
          );
        }),
      ),
    );
  }
}
