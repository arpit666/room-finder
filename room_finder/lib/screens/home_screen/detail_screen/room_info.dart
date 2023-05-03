import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../model/room.dart';

class RoomInfo extends StatelessWidget {
  final Room room;
  final bool hasBath = false;
  RoomInfo(this.room);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          room.hasFPower || room.hasFMeals ?
          Row(
            children: [
              room.hasFPower ?
              MenuInfo(
                  imageUrl: 'assets/icons/power.svg', content: 'Power Backup'):SizedBox(),
              room.hasFMeals ?
              MenuInfo(
                  imageUrl: 'assets/icons/meal-food-icon.svg',
                  content: 'Meals Included\n(Lunch,Dinner)') : SizedBox(),
            ],
          ):SizedBox(),
          room.hasFPower || room.hasFMeals ? SizedBox(height: 10):SizedBox(),
          room.hasFKitchen || room.hasFAirCond ?
          Row(
            children: [
              room.hasFKitchen ?
              MenuInfo(
                  imageUrl: 'assets/icons/kitchen.svg',
                  content: 'Seperate \nKitchen') : SizedBox(),
              room.hasFParking ?
              MenuInfo(
                  imageUrl: 'assets/icons/parking.svg',
                  content: '2-wheeler Parking\n4-wheeler Parking'):SizedBox(),
            ],
          ):SizedBox(),
          room.hasFKitchen || room.hasFAirCond ? SizedBox(height: 10): SizedBox(),
          room.hasFAirCond || room.hasFCCTV ?
          Row(
            children: [
              room.hasFAirCond ?
              MenuInfo(
                  imageUrl: 'assets/icons/air-conditioner-icon.svg',
                  content: 'A.C. Rooms'): SizedBox(),
              room.hasFCCTV ?
              MenuInfo(
                  imageUrl: 'assets/icons/security-camera.svg',
                  content: '24 hr CCTV \nSurveillance') : SizedBox(),
            ],
          ): SizedBox(),
        ],
      ),
    );
  }
}

class MenuInfo extends StatelessWidget {
  final String imageUrl;
  final String content;
  const MenuInfo({Key? key, required this.imageUrl, required this.content})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Expanded(
        child: Row(
          children: [
            SvgPicture.asset(
              imageUrl,
              height: 24,
              width: 24,
            ),
            SizedBox(width: 20),
            Text(
              content,
              style:
                  Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 12),
            )
          ],
        ),
      ),
    );
  }
}
