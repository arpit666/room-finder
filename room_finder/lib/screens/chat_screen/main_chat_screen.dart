import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:room_finder/screens/chat_screen/components/apis.dart';
import 'package:room_finder/screens/home_screen/components/custom_navigation_bar.dart';

import '../../model/user_model.dart';
import 'components/user_chat_card.dart';


class MainChatScreen extends StatefulWidget {
  const MainChatScreen({Key? key}) : super(key: key);

  @override
  State<MainChatScreen> createState() => _MainChatScreenState();
}

class _MainChatScreenState extends State<MainChatScreen> {

  List _list =[];
  final userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    final selectedIndex = PageStorage.of(context).readState(context) ?? 1;
    return Scaffold(
      appBar: AppBar(
        title: Text('My Chats',style: Theme.of(context).textTheme.headlineLarge!.copyWith(fontSize: 18),),
      ),
      body: StreamBuilder(
        stream: APIs.firestore.collection('users').snapshots(),
        builder:(context,AsyncSnapshot<QuerySnapshot>snapshot) {
          switch (snapshot.connectionState) {
          //if data is loading
            case ConnectionState.waiting:
            case ConnectionState.none:
              return const SizedBox();

          //if some or all data is loaded then show it
            case ConnectionState.active:
            case ConnectionState.done:
              final data = snapshot.data!.docs;
              // _list = data
              //     ?.map((e) => UserModel.fromJson(e.data() as  Map<String, dynamic>))
              //     .toList() ??
              //     [];

              final List<UserModel> allUsers = data
                  ?.map((doc) => UserModel.fromJson(doc.data() as Map<String, dynamic>))
                  .toList() ?? [];

              _list = allUsers.where((user) => user.chatIds.contains(userId)).toList();

              if(_list.isNotEmpty){
                return ListView.builder(
                    itemCount: _list.length,
                    padding: EdgeInsets.only(top: 5),
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context,index){return
                        UserChatCard(chatUser: _list[index],);
                    });
              }else{
                return Center(child: Text('No Chats Found!',style: TextStyle(fontSize: 20),));
              }

          }
        }
      ),
      bottomNavigationBar: CustomNavigationBar(
        initialIndex: selectedIndex,
      ),
    );
  }
}
