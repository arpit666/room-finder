import 'package:flutter/material.dart';
import 'package:room_finder/screens/home_screen/detail_screen/about.dart';
import 'package:room_finder/screens/home_screen/detail_screen/detail_app_bar.dart';
import 'package:room_finder/screens/home_screen/detail_screen/detail_bottom_bar.dart';
import 'package:room_finder/screens/home_screen/detail_screen/room_content_intro.dart';
import 'package:room_finder/screens/home_screen/detail_screen/room_info.dart';

import '../../../model/room.dart';
import '../components/room_tile.dart';

class DetailScreen extends StatelessWidget {
  final Room room;
  const DetailScreen({Key? key, required this.room}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DetailAppBar(room),
            SizedBox(
              height: 20,
            ),
            RoomContentIntro(room: room),
            SizedBox(
              height: 15,
            ),
            RoomInfo(room),
            About(room: room,),
          ],
        ),
      ),
      bottomNavigationBar: DetailBottomBar(
        room: room,
      ),
    );
  }
}
