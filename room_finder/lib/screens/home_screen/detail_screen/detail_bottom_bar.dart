import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:room_finder/model/user_model.dart';
import 'package:room_finder/screens/chat_screen/components/apis.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../model/room.dart';
import '../../chat_screen/components/user_chat_screen.dart';

class DetailBottomBar extends StatefulWidget {
  final Room room;

  const DetailBottomBar({Key? key, required this.room}) : super(key: key);

  @override
  State<DetailBottomBar> createState() => _DetailBottomBarState();
}

class _DetailBottomBarState extends State<DetailBottomBar> {
  String ownerName = '';
  String ownerNumber = '';

  Future getOwnerDetails() async {
    final userDocRef =
        FirebaseFirestore.instance.collection('users').doc(widget.room.userId);
    final userDocSnapshot = await userDocRef.get();
    final userDocData = userDocSnapshot.data() as Map<String, dynamic>;
    setState(() {
      ownerName = userDocData['name'];
      ownerNumber = userDocData['phone'];
    });
  }

  @override
  void initState() {
    getOwnerDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      color: Colors.blueGrey.shade50,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    ownerName,
                    style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    '(Owner)',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontSize: 14),
                  )
                ],
              ),
            ),
            Row(
              children: [
                Container(
                  height: 45,
                  width: 45,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.call,
                      color: Colors.green,
                    ),
                    onPressed: () async {
                      if (APIs.user.uid == widget.room.userId) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Can\'t Call Self'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      } else {
                        final Uri launchUri = Uri(
                          scheme: 'tel',
                          path: ownerNumber,
                        );
                        await launchUrl(launchUri);
                      }
                    },
                  ),
                ),
                SizedBox(
                  width: 25,
                ),
                Container(
                  height: 45,
                  width: 45,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: SvgPicture.asset(
                      'assets/icons/chat.svg',
                      colorFilter: ColorFilter.mode(
                          Colors.redAccent.shade700, BlendMode.srcIn),
                    ),
                    onPressed: () async {
                      if (APIs.user.uid == widget.room.userId) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Can\'t Chat with Self'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      } else {
                        final userDocRef = FirebaseFirestore.instance
                            .collection('users')
                            .doc(widget.room.userId);
                        final userDocSnapshot = await userDocRef.get();
                        final userData = userDocSnapshot.data();

                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => UserChatScreen(
                              chatUser: UserModel.fromJson(userData!),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
