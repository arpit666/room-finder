import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:room_finder/screens/profile_screen/modify_room_screen.dart';

import '../../model/room.dart';

class MyRoomTile extends StatelessWidget {
  final Room room;

  MyRoomTile({required this.room});
  String showPrice() {
    String price = '0';
    if (room.priceSingle != '0')
      price = room.priceSingle;
    else if (room.priceTwin != '0')
      price = room.priceTwin;
    else
      price = room.priceThree;
    return price;
  }

  void _navigateToModifyRoomScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ModifyRoomScreen(room: room),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _navigateToModifyRoomScreen(context),
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(8)),
        child: Stack(
          children: [
            Row(
              children: [
                Container(
                  width: 150,
                  height: 80,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(room.imageUrl[0]),
                          fit: BoxFit.cover),
                      borderRadius: BorderRadius.circular(8)),
                ),
                SizedBox(width: 10),
                Flexible(
                  child: Column(
                    children: [
                      Text(room.title,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      Text(
                        room.location,
                        style: TextStyle(
                            fontSize: 14, overflow: TextOverflow.ellipsis),
                      ),
                      SizedBox(height: 10),
                      Text(
                        showPrice(),
                        style: TextStyle(fontSize: 14),
                      )
                    ],
                  ),
                ),
              ],
            ),
            Positioned(child: Icon(Icons.edit),right: 0,)

          ],
        ),
      ),
    );
  }
}
