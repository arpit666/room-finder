import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../model/room.dart';
import '../components/room_tile.dart';

class RoomContentIntro extends StatelessWidget {
  final Room room;
  final double lat = 25.8756;
  final double lng = 80.9115;

  const RoomContentIntro({Key? key, required this.room}) : super(key: key);

  static void navigateTo(double lat, double lng) async {
    var uri =
        Uri.parse("https://www.google.com/maps/search/?api=1&query=$lat,$lng");
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(room.title,
              style: Theme.of(context)
                  .textTheme
                  .headlineLarge!
                  .copyWith(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Text(
                room.location,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontSize: 16),
              ),
              SizedBox(width: 10),
              InkWell(
                onTap: () => navigateTo(room.latitude, room.longitude),
                child: Icon(Icons.location_on),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            room.propertySize,
            style:
                Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 14),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            'Pricing ',
            style: Theme.of(context)
                .textTheme
                .headlineLarge!
                .copyWith(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              if(room.priceSingle != '0')  RoomPriceWidget(price: room.priceSingle, type: "Single"),
              if(room.priceTwin !='0')  RoomPriceWidget(price: room.priceTwin, type: "Twin Sharing"),
              if(room.priceThree != '0')  RoomPriceWidget(price: room.priceThree, type: "Triple Sharing"),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            'Facilities',
            style: Theme.of(context)
                .textTheme
                .headlineLarge!
                .copyWith(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class RoomPriceWidget extends StatelessWidget {
  final String price;
  final String type;

  const RoomPriceWidget({Key? key, required this.price, required this.type})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          type,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 14),
        ),
        RichText(
          text: TextSpan(children: [
            TextSpan(
              text: '₹' + price.toString(),
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium!
                  .copyWith(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text: '/ mon',
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium!
                  .copyWith(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ]),
        ),
      ],
    );
  }
}
