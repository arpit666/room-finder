import 'package:flutter/material.dart';

import '../../../model/room.dart';

class About extends StatelessWidget {
  final Room room;
  const About({Key? key,required this.room}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About',
            style: Theme.of(context)
                .textTheme
                .headlineLarge!
                .copyWith(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          Text(room.description
            ,
            style:
                Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 14),
          )
        ],
      ),
    );
  }
}
