import 'package:flutter/material.dart';
import 'package:room_finder/screens/home_screen/components/favourite_button.dart';

import '../../../model/room.dart';

class DetailAppBar extends StatelessWidget {
  final Room room;
  DetailAppBar(this.room);

  final List<String> images =  [
    'https://images.pexels.com/photos/667838/pexels-photo-667838.jpeg',
    'https://images.rawpixel.com/image_800/cHJpdmF0ZS9sci9pbWFnZXMvd2Vic2l0ZS8yMDIyLTA1L2lzMTI1NDUtaW1hZ2Uta3d2eWZlbzEuanBn.jpg',
    'https://images.pexels.com/photos/667838/pexels-photo-667838.jpeg',
  ];


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      child: Stack(
        children: [
          PageView(
            children: room.imageUrl.isNotEmpty ? room.imageUrl
                .map((e) => Container(
                      width: MediaQuery.of(context).size.width,
                      height: double.infinity,
                      child: Image.network(
                        e,
                        fit: BoxFit.cover,
                        height: double.infinity,
                      ),
                    ))
                .toList() : images
                .map((e) => Container(
              width: MediaQuery.of(context).size.width,
              height: double.infinity,
              child: Image.network(
                e,
                fit: BoxFit.cover,
                height: double.infinity,
              ),
            ))
                .toList(),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      height: 25,
                      width: 25,
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: Colors.grey, shape: BoxShape.circle),
                      child: Icon(
                        Icons.arrow_back,
                        size: 15,
                      ),
                    ),
                  ),
                  // Container(
                  //   padding: EdgeInsets.all(5),
                  //   child: FavoriteButton(isFavorited: false, onPressed: () {}),
                  // )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
